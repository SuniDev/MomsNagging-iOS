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
}

class IntroViewModel: BaseViewModel, ViewModelType {
    struct Input {
        /// IntroViewController 진입
        let didLoadIntro: Driver<Void>
    }
    
    struct Output {
        /// 앱 업데이트 상태
        let appUpdateStatus: PublishSubject<AppUpdateStatus>
        /// 로그인 상태
        let isLogin: PublishSubject<Bool>
        /// 앱 첫 진입 여부
        let firstEntryApp: PublishSubject<Void>
    }
    
    var disposeBag = DisposeBag()
    
    
    /// TODO: App Version API -> App Update Status Check -> firstEntryApp check -> AutoLogin check -> Login API Call
    func transform(input: Input) -> Output {
        
        let appUpdateStatus = PublishSubject<AppUpdateStatus>()
        let isLogin = PublishSubject<Bool>()
        let firstEntryApp = PublishSubject<Void>()
                
        input.didLoadIntro
            .flatMap { requestAppVersion() }
            .map { getAppUpdateStatus($0) }
            .drive( onNext: {
                
            }).disposed(by: disposeBag)
            
        
        
        return Output(appUpdateStatus: appUpdateStatus, isLogin: isLogin, firstEntryApp: firstEntryApp)
    }
}

extension IntroViewModel {
    
    // TODO: Request App Version
    func requestAppVersion() -> Observable<String> {
        return Observable<String>.create { observer -> Disposable in
            observer.onNext("1.0.0")
            observer.onCompleted()
            return Disposables.create()
        }.share()
    }
    
    // TODO: App Update Status Check
    func getAppUpdateStatus(_ version: String) -> AppUpdateStatus {
        return AppUpdateStatus.latestVersion
    }
    
    func isFirstEntryApp() -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let isFirstEntry = Common.getUserDefaultsObject(forKey: .isFirstEntryApp) as? Bool {
                observer.onNext(isFirstEntry)
                observer.onCompleted()
            } else {
                observer.onNext(false)
                observer.onCompleted()
            }
            return Disposables.create()
        }.debug()
    }
    
}
