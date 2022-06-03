//
//  DeleteAccountViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/25.
//

import Foundation
import Moya
import SwiftyJSON
import RxSwift
import RxCocoa

class DeleteAccountViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        let willAppearView: Driver<Void>
        let btnBackTapped: Driver<Void>
        let btnSelectTapped: Driver<Void>
        let reasonItemSelected: Driver<IndexPath>
        let btnDeleteAccountTapped: Driver<Void>
        let confirmDeleteAlertHandler: Driver<Bool>
        let successDeleteAlertHandler: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let goToBack: Driver<Void>
        let reasonItems: Driver<[String]>
        let isShowReasonList: Driver<Bool>
        let isShowPlaceHolder: Driver<Bool>
        let setReasonText: Driver<String>
        let isEnabledBtnDeleteAccount: Driver<Bool>
        let showConfirmDeleteAlert: Driver<Alert>
        let showSuccessDeleteAlert: Driver<Alert>
        let goToLogin: Driver<LoginViewModel>
    }
    
    func transform(input: Input) -> Output {
        
        let isShowReasonList = BehaviorRelay<Bool>(value: false)
        let isShowPlaceHolder = BehaviorRelay<Bool>(value: false)
        let textReason = BehaviorRelay<String>(value: "")
        
        let reasonItems = BehaviorRelay<[String]>(value: [])
        input.willAppearView
            .asObservable()
            .flatMapLatest { _ -> Observable<[String]> in
                return self.getReasonItems()
            }.subscribe(onNext: { items in
                reasonItems.accept(items)
            }).disposed(by: disposeBag)
        
        let setReasonText = textReason.filter({ !$0.isEmpty })
        
        let isEnabledBtnDeleteAccount = textReason.map { !$0.isEmpty }
        
        input.btnSelectTapped
            .drive(onNext: {
                isShowReasonList.accept(!isShowReasonList.value)
            }).disposed(by: disposeBag)
        
        isShowReasonList
            .subscribe(onNext: { isShow in
                if isShow {
                    isShowPlaceHolder.accept(textReason.value.isEmpty)
                } else {
                    isShowPlaceHolder.accept(false)
                }
            }).disposed(by: disposeBag)
        
        input.reasonItemSelected
            .drive(onNext: { indexPath in
                textReason.accept(reasonItems.value[indexPath.row])
                isShowReasonList.accept(false)
            }).disposed(by: disposeBag)
        
        let showConfirmDeleteAlert = input.btnDeleteAccountTapped
            .asObservable()
            .flatMapLatest { _ -> Observable<Alert> in
                let alert = Alert(title: "", message: STR_DELETE_ACCOUNT, cancelTitle: STR_NO, doneTitle: STR_YES)
                return Observable.just(alert)
            }
        
        let requestDeleteUser = input.confirmDeleteAlertHandler
            .asObservable()
            .filter({ $0 == true })
            .flatMapLatest { _ -> Observable<UserResult> in
                self.isLoading.accept(true)
                return self.requestDeleteUser(textReason.value)
            }.share()
        
        let showSuccessDeleteAlert = requestDeleteUser
            .filter({ $0.id != nil })
            .flatMapLatest { _ -> Observable<Alert> in
                let alert = Alert(title: "", message: STR_SUCCESS_ACCOUNT, doneTitle: STR_CLOSE)
                return Observable.just(alert)
            }
        
        requestDeleteUser
            .bind(onNext: { _ in
                self.isLoading.accept(false)
            }).disposed(by: disposeBag)
        
        let goToLogin = input.successDeleteAlertHandler
            .asObservable()
            .map { _ -> LoginViewModel in
                CommonUser.logout()
                let viewModel = LoginViewModel(withService: self.provider)
                return viewModel
            }
        
        return Output(goToBack: input.btnBackTapped,
                      reasonItems: reasonItems.asDriverOnErrorJustComplete(),
                      isShowReasonList: isShowReasonList.asDriverOnErrorJustComplete(),
                      isShowPlaceHolder: isShowPlaceHolder.asDriverOnErrorJustComplete(),
                      setReasonText: setReasonText.asDriverOnErrorJustComplete(),
                      isEnabledBtnDeleteAccount: isEnabledBtnDeleteAccount.asDriverOnErrorJustComplete(),
                      showConfirmDeleteAlert: showConfirmDeleteAlert.asDriverOnErrorJustComplete(),
                      showSuccessDeleteAlert: showSuccessDeleteAlert.asDriverOnErrorJustComplete(),
                      goToLogin: goToLogin.asDriverOnErrorJustComplete())
    }
}
extension DeleteAccountViewModel {
    func getReasonItems() -> Observable<[String]> {
        return Observable<[String]>.create { observer -> Disposable in
            
            var items = [String]()
            items.append("서비스 이용이 불편해요.")
            items.append("고객응대가 불만이에요.")
            items.append("비슷한 서비스 앱이 더 좋아요.")
            items.append("자주 사용하지 않아요.")
            observer.onNext(items)
                         
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
// MARK: - API
extension DeleteAccountViewModel {
    // TODO: API 탈퇴 사유 추가
    private func requestDeleteUser(_ reason: String) -> Observable<UserResult> {
        let request = DeleteUserRequest()
        return self.provider.userService.deleteUser(request: request)
    }
    
}
