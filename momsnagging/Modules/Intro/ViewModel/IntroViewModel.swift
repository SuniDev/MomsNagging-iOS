//
//  IntroViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftExt
import FirebaseRemoteConfig

class IntroViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
        
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        /// IntroView 진입
        let willAppearIntro: Driver<Void>
        /// 업데이트 핸들러
        let foreceUpdatePopupHandler: Driver<Void>
        let selectUpdatePopupHandler: Driver<Bool>
        /// 업데이트 상태 핸들러
        let getppUpdateStatusHandler: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 앱 업데이트 상태
        let forceUpdateStatus: Driver<Void>
        let selectUpdateStatus: Driver<Void>
        /// 앱 첫 진입 여부
        let goToOnboarding: Driver<OnboardingViewModel>
        /// 로그인 이동
        let goToLogin: Driver<LoginViewModel>
        /// 메인 이동
        let goToMain: Driver<MainContainerViewModel>
        /// 강제 업데이트
        let goToForceUpdate: Driver<Void>
        /// 선택 업데이트
        let goToSelectUpdate: Driver<Void>
        /// 네트워크 오류
        let networkError: Driver<Void>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        // MARK: - App Update Status
        let appUpdateStatus = Observable.merge(input.willAppearIntro.asObservable(), input.getppUpdateStatusHandler.asObservable())
                .flatMapLatest { () -> Observable<AppUpdateStatus> in
                    return self.getAppUpdateStatus()
                }.share()
        
        let forceUpdateStatus = appUpdateStatus
            .filter { status in status == .forceUpdate }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let selectUpdateStatus = appUpdateStatus
            .filter { status in status == .selectUpdate }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let networkError = appUpdateStatus
            .filter { status in status == .error }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let selectUpdatePopupHandler = input.selectUpdatePopupHandler.asObservable().share()
        
        let selectUpdate = selectUpdatePopupHandler.filter({ $0 == true }).mapToVoid()
                
        // MARK: - First Entry App
        let entryApp = Observable.merge(selectUpdatePopupHandler.mapToVoid(),
                                        appUpdateStatus.filter { status in status == .latestVersion }.mapToVoid())
        
        let isFirstEntryApp = entryApp
            .flatMapLatest { _ -> Observable<Bool> in
                return self.isFirstEntryApp()
            }.share()
        
        appUpdateStatus
            .subscribe(onNext: { status in
                Common.appUpdateStatus = status
            }).disposed(by: disposeBag)
        
        let goToOnboarding = isFirstEntryApp
            .filter { isFirst in isFirst == true }
            .map { _ -> OnboardingViewModel in
                // GA - 앱 첫 진입
                CommonAnalytics.logEvent(.first_app_entry)
                let viewModel = OnboardingViewModel(withService: self.provider)
                return viewModel
            }
    
        // MARK: - Login
        let isAutoLogin = isFirstEntryApp
            .filter { isFirst in isFirst == false }
            .flatMapLatest { _ -> Observable<Bool> in
                return self.isAutoLogin()
            }.share()
        
       let getAuthorization = isAutoLogin
            .filter({ $0 == true })
            .flatMapLatest { _ -> Observable<String?> in
                return self.getAuthorization()
            }.share()
                
        let requestGetUser = getAuthorization
            .filter({ $0 != nil })
            .map { CommonUser.authorization = $0 }
            .flatMapLatest { _ -> Observable<User> in
                return self.requestGetUser()
            }.share()
        
        let setUser = requestGetUser
            .filter { $0.id != nil }
            .share()
        
        setUser
            .flatMapLatest { _ -> Observable<GradeLastWeek> in
                return self.requestLastWeek()
            }.map { $0.newGrade ?? false }
            .subscribe(onNext: { new in
                CommonUser.isNewEvaluation = new
            }).disposed(by: disposeBag)
        
        setUser
            .subscribe(onNext: { user in
                CommonUser.setUser(user)
            }).disposed(by: disposeBag)
        
        let goToMain = setUser
            .map { _ -> MainContainerViewModel in
                let viewModel = MainContainerViewModel()
                return viewModel
            }
        
        let goToLogin = Observable.merge(
            isAutoLogin.filter({ $0 == false }).mapToVoid(),
            getAuthorization.filter({ $0 == nil }).mapToVoid(),
            requestGetUser.filter { $0.id == nil }.mapToVoid()
        ).map { _ -> LoginViewModel in
            let viewModel = LoginViewModel(withService: self.provider)
            return viewModel
        }
        
        return Output(forceUpdateStatus: forceUpdateStatus,
                      selectUpdateStatus: selectUpdateStatus,
                      goToOnboarding: goToOnboarding.asDriverOnErrorJustComplete(),
                      goToLogin: goToLogin.asDriverOnErrorJustComplete(),
                      goToMain: goToMain.asDriverOnErrorJustComplete(),
                      goToForceUpdate: input.foreceUpdatePopupHandler,
                      goToSelectUpdate: selectUpdate.asDriverOnErrorJustComplete(),
                      networkError: networkError)
    }
}

extension IntroViewModel {
    
    func getAppUpdateStatus() -> Observable<AppUpdateStatus> {
        return Observable<AppUpdateStatus>.create { observer -> Disposable in
            let remoteConfig = RemoteConfig.remoteConfig()
            let setting = RemoteConfigSettings()
            setting.minimumFetchInterval = 0
            remoteConfig.configSettings = setting
            remoteConfig.setDefaults(fromPlist: "AppUpdateVersion")
            
             remoteConfig.fetch { status, _ in
                 if status == .success {
                     remoteConfig.activate(completion: nil)
                 } else {
                     Log.error("AppUpdateVersion Remote Config Error")
                     observer.onNext(.error)
                     observer.onCompleted()
                 }
                 
                 let forceVresion = remoteConfig["forceUpdateVersion"].stringValue ?? "0.0.0"
                 let lastVersion = remoteConfig["latestUpdateVersion"].stringValue ?? "0.0.0"
                 let currentVersion = TaviCommon.getVersion()
                 
                 Log.debug(lastVersion, forceVresion)
                 
                 if lastVersion == "0.0.0" {
                     observer.onNext(.error)
                     observer.onCompleted()
                 }
                 
                 let forceSplit = forceVresion.split(separator: ".")
                 let latestSplit = lastVersion.split(separator: ".")
                 
                 if forceSplit.count != 3 || latestSplit.count != 3 {
                     observer.onNext(.error)
                     observer.onCompleted()
                 }
                 
                 // 버전 체크
                 if self.isOldVersion(latest: forceVresion, current: currentVersion) {
                     observer.onNext(.forceUpdate)
                     observer.onCompleted()
                 } else {
                     if self.isOldVersion(latest: lastVersion, current: currentVersion) {
                         observer.onNext(.selectUpdate)
                         observer.onCompleted()
                     } else {
                         // 최신 버전
                         observer.onNext(.latestVersion)
                         observer.onCompleted()
                     }
                 }
             }
            
            return Disposables.create()
        }
    }
    
    fileprivate func isOldVersion(latest: String, current: String) -> Bool {
        let latestSplit = latest.components(separatedBy: ".")
        let currentSplit = current.components(separatedBy: ".")
        for (latest, current) in zip(latestSplit, currentSplit) {
            if let lastInt = Int(latest), let currentInt = Int(current) {
                if currentInt < lastInt {
                    return true
                } else if currentInt > lastInt {
                    return false
                }
            }
        }
        return false
    }
    
    func isFirstEntryApp() -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let isFirstEntry = Common.getUserDefaultsObject(forKey: .isFirstEntryApp) as? Bool {
                observer.onNext(isFirstEntry)
                observer.onCompleted()
            } else {
                Common.setUserDefaults(false, forKey: .isFirstEntryApp)
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func isAutoLogin() -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let isAuto = Common.getUserDefaultsObject(forKey: .isAutoLogin) as? Bool {
                observer.onNext(isAuto)
                observer.onCompleted()
            } else {
                observer.onNext(false)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getAuthorization() -> Observable<String?> {
        return Observable<String?>.create { observer -> Disposable in
            observer.onNext(Common.getKeychainValue(forKey: .authorization))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}

// MARK: API
extension IntroViewModel {
    private func requestGetUser() -> Observable<User> {
        let request = GetUserRequest()
        return self.provider.userService.getUser(request: request)
    }
    
    private func requestLastWeek() -> Observable<GradeLastWeek> {
        let request = GradeLastWeekRequest()
        return self.provider.gradeService.lastWeek(request: request)
    }
}
