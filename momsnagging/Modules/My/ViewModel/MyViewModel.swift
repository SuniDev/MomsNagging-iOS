//
//  MyViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa

class MyViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
        /// 설정
        let btnSettingTapped: Driver<Void>
        /// 각오 수정
        let btnModifyMessageTapped: Driver<Void>
        /// 호칭 설정
        let btnNicknameSetting: Driver<Void>
        /// 잔소리 강도 설정
        let rbFondMomTapped: Driver<Void>
        let rbCoolMomTapped: Driver<Void>
        let rbAngryMomTapped: Driver<Void>
        /// PUSH 알림 설정
        let btnPushSettingTapped: Driver<Void>
        /// 로그아웃
        let btnLogoutTapped: Driver<Void>
    }
    // MARK: - Output
    struct Output {
        /// 설정
        let goToSetting: Driver<Void>
        /// 각오 수정
        let showMessageModifyAlert: Driver<(String, String)>
        /// 호칭 설정
        let showNicknameSettingAlert: Driver<(String, String)>
        /// 잔소리 강도 설정
        let setNaggingIntensity: Driver<NaggingIntensity>
        /// PUSH 알림 설정
        let goToPushSetting: Driver<Void>
        /// 로그아웃
        let showLogoutAlert: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let showMessageModifyAlert = input.btnModifyMessageTapped
            .asObservable()
            .flatMapLatest { _ -> Observable<(String, String)> in
                return Observable.just((STR_MESSAGE_MODIFY, STR_MESSAGE_MODIFY_DONE))
            }
        
        let showNicknameSettingAlert = input.btnNicknameSetting
            .asObservable()
            .flatMapLatest { _ -> Observable<(String, String)> in
                return Observable.just((STR_NICKNAME_SETTING, STR_NICKNAME_SETTING_DONE))
            }
        
        // 잔소리 강도 설정
        let setNaggingIntensity = BehaviorRelay<NaggingIntensity>(value: NaggingIntensity.fondMom)
        
        input.rbFondMomTapped
            .drive(onNext: {
                setNaggingIntensity.accept(.fondMom)
            }).disposed(by: disposeBag)
        input.rbCoolMomTapped
            .drive(onNext: {
                setNaggingIntensity.accept(.coolMom)
            }).disposed(by: disposeBag)
        input.rbAngryMomTapped
            .drive(onNext: {
                setNaggingIntensity.accept(.angryMom)
            }).disposed(by: disposeBag)

        let showLogoutAlert = input.btnLogoutTapped
            .asObservable()
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_LOGOUT)
            }
        
        return Output(goToSetting: input.btnSettingTapped,
                      showMessageModifyAlert: showMessageModifyAlert.asDriver(onErrorJustReturn: (STR_MESSAGE_MODIFY, STR_NO)),
                      showNicknameSettingAlert: showNicknameSettingAlert.asDriver(onErrorJustReturn: (STR_NICKNAME_SETTING, STR_NICKNAME_SETTING_DONE)),
                      setNaggingIntensity: setNaggingIntensity.asDriverOnErrorJustComplete(),
                      goToPushSetting: input.btnPushSettingTapped,
                      showLogoutAlert: showLogoutAlert.asDriver(onErrorJustReturn: STR_LOGOUT))
    }
}
// MARK: - API
extension MyViewModel {
    
}
