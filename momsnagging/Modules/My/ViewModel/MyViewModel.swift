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
        let messageModifyAlertDoneHandler: Driver<String?>
        /// 호칭 설정
        let btnNicknameSetting: Driver<Void>
        let nicknameSettingAlertDoneHandler: Driver<String?>
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
        /// 각오
        let message: Driver<String>
        let showMessageModifyAlert: Driver<Alert>
        /// 호칭 설정
        let showNicknameSettingAlert: Driver<Alert>
        /// 잔소리 강도 설정
        let setNaggingIntensity: Driver<NaggingLevel>
        /// PUSH 알림 설정
        let goToPushSetting: Driver<Void>
        /// 로그아웃
        let showLogoutAlert: Driver<String>
    }
    
    func transform(input: Input) -> Output {

        // 각오
        let message = BehaviorRelay<String>(value: STR_MESSAGE_DEFAULT)
        let showMessageModifyAlert = PublishRelay<Alert>()
        
        input.btnModifyMessageTapped
            .drive(onNext: { _ in
                let alert = Alert(title: STR_MESSAGE_MODIFY_TITLE, message: "", cancelTitle: STR_CANCEL, doneTitle: STR_MESSAGE_MODIFY_DONE, textFieldText: message.value, textFieldPlaceholder: STR_MESSAGE_MODIFY_PLACEHOLDER)
                showMessageModifyAlert.accept(alert)
            }).disposed(by: disposeBag)
        
        let messageModifyAlertDoneHandler = input.messageModifyAlertDoneHandler.asObservable().share()
        let messageModifyText = BehaviorRelay<String>(value: "")
        messageModifyAlertDoneHandler
            .bind(onNext: { message in
                messageModifyText.accept(message ?? "")
            }).disposed(by: disposeBag)
        
        let isValidMessage = messageModifyAlertDoneHandler
            .flatMapLatest { message -> Observable<Bool> in
                if let message = message {
                    if message.count < 31 {
                        return Observable.just(true)
                    }
                }
                return Observable.just(false)
            }.share()
        
        isValidMessage
            .filter({ $0 == true })
            .bind(onNext: { _ in
                // TODO: 각오 수정 API
                message.accept(messageModifyText.value)
            }).disposed(by: disposeBag)
        
        isValidMessage
            .filter({ $0 == false })
            .bind(onNext: { _ in
                let alert = Alert(title: STR_MESSAGE_MODIFY_TITLE, message: STR_MESSAGE_MODIFY_ERROR, cancelTitle: STR_CANCEL, doneTitle: STR_MESSAGE_MODIFY_DONE, textFieldText: message.value, textFieldPlaceholder: STR_MESSAGE_MODIFY_PLACEHOLDER)
                showMessageModifyAlert.accept(alert)
            }).disposed(by: disposeBag)
                
        // 호칭
        let nickName = BehaviorRelay<String>(value: "")
        let showNicknameSettingAlert = PublishRelay<Alert>()
        
        input.btnNicknameSetting
            .drive(onNext: { _ in
                let alert = Alert(title: STR_NICKNAME_SETTING_TITLE, message: "", cancelTitle: STR_CANCEL, doneTitle: STR_NICKNAME_SETTING_DONE, textFieldText: nickName.value, textFieldPlaceholder: STR_NICKNAME_SETTING_PLACEHOLDER)
                showNicknameSettingAlert.accept(alert)
            }).disposed(by: disposeBag)
        
        let isValidName = input.nicknameSettingAlertDoneHandler
            .asObservable()
            .flatMapLatest { name -> Observable<Bool> in
                return self.isValidName(name)
            }.share()
        
        isValidName
            .filter({ $0 == true })
            .bind(onNext: { _ in
                // TODO: 호칭 수정 API
            }).disposed(by: disposeBag)
        
        isValidName
            .filter({ $0 == false })
            .bind(onNext: { _ in
                let alert = Alert(title: STR_NICKNAME_SETTING_TITLE, message: STR_NICKNAME_SETTING_ERROR, cancelTitle: STR_CANCEL, doneTitle: STR_NICKNAME_SETTING_DONE, textFieldText: nickName.value, textFieldPlaceholder: STR_NICKNAME_SETTING_PLACEHOLDER)
                showNicknameSettingAlert.accept(alert)
            }).disposed(by: disposeBag)
                
        // 잔소리 강도 설정
        let setNaggingIntensity = BehaviorRelay<NaggingLevel>(value: NaggingLevel.fondMom)
        
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
                      message: message.asDriver(onErrorJustReturn: " "),
                      showMessageModifyAlert: showMessageModifyAlert.asDriverOnErrorJustComplete(),
                      showNicknameSettingAlert: showNicknameSettingAlert.asDriverOnErrorJustComplete(),
                      setNaggingIntensity: setNaggingIntensity.asDriverOnErrorJustComplete(),
                      goToPushSetting: input.btnPushSettingTapped,
                      showLogoutAlert: showLogoutAlert.asDriver(onErrorJustReturn: STR_LOGOUT))
    }
}
extension MyViewModel {
    func isValidName(_ name: String?) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let text = name {
                let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\s]{1,10}$"
                if text.range(of: pattern, options: .regularExpression) != nil {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            } else {
                observer.onNext(false)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
