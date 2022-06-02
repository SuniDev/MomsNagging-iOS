//
//  MyViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/30.
//

import Foundation
import RxSwift
import RxCocoa

class MyViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        /// 설정
        let btnSettingTapped: Driver<Void>
        /// 각오 수정
        let btnModifyStatusTapped: Driver<Void>
        let statusModifyAlertDoneHandler: Driver<String?>
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
        let logoutAlertDoneHandler: Driver<Void>
    }
    // MARK: - Output
    struct Output {
        /// 설정
        let goToSetting: Driver<Void>
        /// 아이디
        let id: Driver<String>
        /// 각오
        let statusMsg: Driver<String>
        let showStatusModifyAlert: Driver<Alert>
        /// 호칭 설정
        let nickName: Driver<String>
        let showNicknameSettingAlert: Driver<Alert>
        /// 잔소리 강도 설정
        let setNaggingLevel: Driver<NaggingLevel>
        /// PUSH 알림 설정
        let goToPushSetting: Driver<PushSettingViewModel>
        /// 로그아웃
        let showLogoutAlert: Driver<String>
        let goToLogin: Driver<LoginViewModel>
    }
    
    func transform(input: Input) -> Output {
        
        // 아이디
        let id = BehaviorRelay<String>(value: CommonUser.personalId ?? "")

        // 각오
        let statusMsg = BehaviorRelay<String>(value: CommonUser.statusMsg.isEmpty == true ? STR_STATUSMSG_DEFAULT : CommonUser.statusMsg)
        let statusModifyText = BehaviorRelay<String>(value: "")
        
        // 호칭
        let nickName = BehaviorRelay<String>(value: CommonUser.nickName ?? "자식")
        let nicknameModifyText = BehaviorRelay<String>(value: "")
        
        // 잔소리 강도
        let setNaggingLevel = BehaviorRelay<NaggingLevel>(value: CommonUser.naggingLevel)
        
        // 수정 business logic
        let requestPutUserTrigger = PublishRelay<PutUserRequest>()
        
        let requestPutUser = requestPutUserTrigger
            .flatMapLatest { request in
                return self.requestPutUser(request)
            }.share()
        
        let successPutUser = requestPutUser
            .filter({ $0.id != nil })
            .share()
        
        let failPutUser = requestPutUser
            .filter({ $0.id == nil })
            .share()
        
        failPutUser
            .subscribe(onNext: { _ in
                // TODO: 네트워크 실패
                statusMsg.accept(CommonUser.statusMsg.isEmpty == true ? STR_STATUSMSG_DEFAULT : CommonUser.statusMsg)
                nickName.accept(CommonUser.nickName ?? "자식")
                setNaggingLevel.accept(CommonUser.naggingLevel)
            }).disposed(by: disposeBag)
        
        let requestGetUser = successPutUser
            .flatMapLatest { _ in
                return self.requestGetUser()
            }.share()
                
        requestGetUser
            .filter({ $0.id != nil })
            .subscribe(onNext: { user in
                CommonUser.setUser(user)
            }).disposed(by: disposeBag)
        
        // 각오 business logic
        let showStatusModifyAlert = PublishRelay<Alert>()
        input.btnModifyStatusTapped
            .drive(onNext: { _ in
                let alert = Alert(title: STR_STATUSMSG_MODIFY_TITLE, message: "", cancelTitle: STR_CANCEL, doneTitle: STR_STATUSMSG_MODIFY_DONE, textFieldText: statusMsg.value, textFieldPlaceholder: STR_STATUSMSG_MODIFY_PLACEHOLDER)
                showStatusModifyAlert.accept(alert)
            }).disposed(by: disposeBag)
        
        let statusModifyAlertDoneHandler = input.statusModifyAlertDoneHandler.asObservable().share()
        statusModifyAlertDoneHandler
            .bind(onNext: { statusMsg in
                statusModifyText.accept(statusMsg ?? "")
            }).disposed(by: disposeBag)
        
        let isValidStatusMsg = statusModifyAlertDoneHandler
            .flatMapLatest { statusMsg -> Observable<Bool> in
                if let statusMsg = statusMsg {
                    if statusMsg.count < 31 {
                        return Observable.just(true)
                    }
                }
                return Observable.just(false)
            }.share()        
        
        isValidStatusMsg
            .filter({ $0 == true })
            .bind(onNext: { _ in
                statusMsg.accept(statusModifyText.value)
                
                var request = PutUserRequest()
                request.statusMsg = statusModifyText.value
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        isValidStatusMsg
            .filter({ $0 == false })
            .bind(onNext: { _ in
                let alert = Alert(title: STR_STATUSMSG_MODIFY_TITLE, message: STR_STATUSMSG_MODIFY_ERROR, cancelTitle: STR_CANCEL, doneTitle: STR_STATUSMSG_MODIFY_DONE, textFieldText: statusMsg.value, textFieldPlaceholder: STR_STATUSMSG_MODIFY_PLACEHOLDER)
                showStatusModifyAlert.accept(alert)
            }).disposed(by: disposeBag)
                
        // 호칭 business logic
        let showNicknameSettingAlert = PublishRelay<Alert>()
        
        input.btnNicknameSetting
            .drive(onNext: { _ in
                let alert = Alert(title: STR_NICKNAME_SETTING_TITLE, message: "", cancelTitle: STR_CANCEL, doneTitle: STR_NICKNAME_SETTING_DONE, textFieldText: nickName.value, textFieldPlaceholder: STR_NICKNAME_SETTING_PLACEHOLDER)
                showNicknameSettingAlert.accept(alert)
            }).disposed(by: disposeBag)
        
        let isValidName = input.nicknameSettingAlertDoneHandler
            .asObservable()
            .flatMapLatest { name -> Observable<Bool> in
                nicknameModifyText.accept(name ?? nickName.value)
                return self.isValidName(name)
            }.share()
        
        isValidName
            .filter({ $0 == true })
            .bind(onNext: { _ in
                nickName.accept(nicknameModifyText.value)
                
                var request = PutUserRequest()
                request.nickName = nicknameModifyText.value
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        isValidName
            .filter({ $0 == false })
            .bind(onNext: { _ in
                let alert = Alert(title: STR_NICKNAME_SETTING_TITLE, message: STR_NICKNAME_SETTING_ERROR, cancelTitle: STR_CANCEL, doneTitle: STR_NICKNAME_SETTING_DONE, textFieldText: nickName.value, textFieldPlaceholder: STR_NICKNAME_SETTING_PLACEHOLDER)
                showNicknameSettingAlert.accept(alert)
            }).disposed(by: disposeBag)
        
        // 잔소리 강도 business logic
        let requestNaggingLevel = PublishRelay<Int>()
        input.rbFondMomTapped
            .drive(onNext: {
                setNaggingLevel.accept(.fondMom)
                requestNaggingLevel.accept(0)
            }).disposed(by: disposeBag)
        input.rbCoolMomTapped
            .drive(onNext: {
                setNaggingLevel.accept(.coolMom)
                requestNaggingLevel.accept(1)
            }).disposed(by: disposeBag)
        input.rbAngryMomTapped
            .drive(onNext: {
                setNaggingLevel.accept(.angryMom)
                requestNaggingLevel.accept(2)
            }).disposed(by: disposeBag)
        
        requestNaggingLevel
            .subscribe(onNext: { level in
                var request = PutUserRequest()
                request.naggingLevel = level
                requestPutUserTrigger.accept(request)
            }).disposed(by: disposeBag)
        
        let showLogoutAlert = input.btnLogoutTapped
            .asObservable()
            .flatMapLatest { _ -> Observable<String> in
                return Observable.just(STR_LOGOUT)
            }
        
        let goToLogin = input.logoutAlertDoneHandler
            .asObservable()
            .map { _ -> LoginViewModel in
                CommonUser.logout()
                let viewModel = LoginViewModel(withService: self.provider)
                return viewModel
            }
        
        let goToPushSetting = input.btnPushSettingTapped
            .asObservable()
            .map { _ -> PushSettingViewModel in
                let viewModel = PushSettingViewModel(withService: self.provider)
                return viewModel
            }
        
        return Output(goToSetting: input.btnSettingTapped,
                      id: id.asDriverOnErrorJustComplete(),
                      statusMsg: statusMsg.asDriver(onErrorJustReturn: STR_STATUSMSG_DEFAULT),
                      showStatusModifyAlert: showStatusModifyAlert.asDriverOnErrorJustComplete(),
                      nickName: nickName.asDriverOnErrorJustComplete(),
                      showNicknameSettingAlert: showNicknameSettingAlert.asDriverOnErrorJustComplete(),
                      setNaggingLevel: setNaggingLevel.asDriverOnErrorJustComplete(),
                      goToPushSetting: goToPushSetting.asDriverOnErrorJustComplete(),
                      showLogoutAlert: showLogoutAlert.asDriver(onErrorJustReturn: STR_LOGOUT),
                      goToLogin: goToLogin.asDriverOnErrorJustComplete())
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

// MARK: - API
extension MyViewModel {
    private func requestGetUser() -> Observable<User> {
        let request = GetUserRequest()
        return self.provider.userService.getUser(request: request)
    }
    
    private func requestPutUser(_ request: PutUserRequest) -> Observable<UserResult> {
        return self.provider.userService.putUser(request: request)
    }
}
