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
        /// IntroViewController 진입
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
        
        let failLogin = isAutoLogin
            .filter { isAuto in isAuto == false }
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        return Output(forceUpdateStatus: forceUpdateStatus, selectUpdateStatus: selectUpdateStatus, firstEntryApp: firstEntryApp, failLogin: failLogin)
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
    
}
