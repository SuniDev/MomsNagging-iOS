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
import CoreMIDI

enum AppUpdateStatus {
    case forceUpdate
    case selectUpdate
    case latestVersion
    case error
}

class IntroViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
        /// IntroView 진입
        let willAppearIntro: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 앱 업데이트 상태
        let forceUpdateStatus: Driver<Void>
        let selectUpdateStatus: Driver<Void>
        /// 앱 첫 진입 여부
        let firstEntryApp: Driver<Void>
        /// 로그인 상태
        // TODO: Request Login API
//        let successLogin: Driver<Bool>
        let failLogin: Driver<Void>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        // MARK: - App Update Status
        // TODO: Request App Version API
        let appUpdateStatus = input.willAppearIntro
            .asObservable()
            .flatMapLatest { () -> Observable<AppUpdateStatus> in
                return self.getAppUpdateStatus("1.0.0")
            }.share()
        
        let forceUpdateStatus = appUpdateStatus
            .filter { status in status == .forceUpdate }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let selectUpdateStatus = appUpdateStatus
            .filter { status in status == .selectUpdate }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        // MARK: - First Entry App
        let isFirstEntryApp = appUpdateStatus
            .filter { status in status == .latestVersion }
            .flatMapLatest { _ -> Observable<Bool> in
                return self.isFirstEntryApp()
            }.share()
        
        let firstEntryApp = isFirstEntryApp
            .filter { isFirst in isFirst == true }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        // MARK: - Login
        let isAutoLogin = isFirstEntryApp
            .filter { isFirst in isFirst == false }
            .flatMapLatest { _ -> Observable<Bool> in
                return self.isAutoLogin()
            }.share()
        
       let getUserToken = isAutoLogin
            .filter({ $0 == true })
            .flatMapLatest { _ -> Observable<String?> in
                return self.getUserToken()
            }.share()
        
        // TODO: requestLogin
//        let requestLogin = getUserToken
//            .filter{ $0 != nil }
//            .flatMapLatest { token -> }
        
    
        let failLogin = Observable.merge(
            isAutoLogin.filter({ $0 == false}).mapToVoid(),
            getUserToken.filter({ $0 == nil }).mapToVoid()
        )
        
        return Output(forceUpdateStatus: forceUpdateStatus,
                      selectUpdateStatus: selectUpdateStatus,
                      firstEntryApp: firstEntryApp,
                      failLogin: failLogin.mapToVoid().asDriverOnErrorJustComplete())
    }
}

extension IntroViewModel {
    
    // TODO: Request App Version
    
    // TODO: App Update Status Logic
    func getAppUpdateStatus(_ version: String) -> Observable<AppUpdateStatus> {
        return Observable<AppUpdateStatus>.create { observer -> Disposable in
            observer.onNext(AppUpdateStatus.latestVersion)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func isFirstEntryApp() -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let isFirstEntry = Common.getUserDefaultsObject(forKey: .isFirstEntryApp) as? Bool {
                observer.onNext(isFirstEntry)
                observer.onCompleted()
            } else {
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
    
    func getUserToken() -> Observable<String?> {
        return Observable<String?>.create { observer -> Disposable in
            // TODO: 키체인 토큰 가져오기
            observer.onNext(nil)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
// MARK: API
extension IntroViewModel {
    private func requestLogin(token: String) {
        let loginRequest = LoginRequest()
        
    }
}
