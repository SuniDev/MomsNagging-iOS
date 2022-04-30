//
//  IDSettingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/28.
//

import Foundation
import RxSwift
import RxCocoa

class IDSettingViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    private let loginInfo: BehaviorRelay<LoginInfo>
    
    init(loginInfo: LoginInfo) {
        self.loginInfo = BehaviorRelay<LoginInfo>(value: loginInfo)
    }
    
    // MARK: - Input
    struct Input {
        let textID: Driver<String?>
        let editingDidBeginID: Driver<Void>
        let editingDidEndID: Driver<Void>
        let btnDoneTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let editingID: Driver<Void>
        /// 디폴트 상태
        let defaultID: Driver<Void>
        /// 유효하지 않은 아이디
        let invalidID: Driver<Void>
        /// 중복 아이디
        let duplicateID: Driver<Void>
        /// 사용 가능 아이디
        let availableID: Driver<Void>
        /// 사용 불가 아이디
        let unavailableID: Driver<Void>
        /// 아이디 설정 완료
        let successIDSetting: Driver<LoginInfo>
    }
    
    func transform(input: Input) -> Output {
        
        let textID = BehaviorRelay<String>(value: "")
        let isEditingID = BehaviorRelay<Bool>(value: false)
        let isEmptyID = BehaviorRelay<Bool>(value: false)
        let isGoodID = BehaviorRelay<Bool>(value: false)
        
        input.textID
            .drive(onNext: { text in
                let text = text ?? ""
                textID.accept(text)
                isEmptyID.accept(text.isEmpty)
            }).disposed(by: disposeBag)
        
        input.editingDidBeginID
            .drive(onNext: { () in
                isEditingID.accept(true)
                isGoodID.accept(false)
            }).disposed(by: disposeBag)
        
        input.editingDidEndID
            .drive(onNext: { () in
                isEditingID.accept(false)
            }).disposed(by: disposeBag)
        
        let editingID = isEditingID
            .filter { isEditing in  isEditing == true }
            .mapToVoid()
        
        let isDefaultID = input.editingDidEndID
            .asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                Observable.just(isEmptyID.value)
            }
        
        let defaultID = isDefaultID
            .filter { isDefault in isDefault == true }
            .mapToVoid()
        
        // 사용 가능 여부 확인 (영어, 숫자만 가능)
        let isValidID = isDefaultID
            .filter { isDefault in isDefault == false }
            .flatMapLatest { _ -> Observable<Bool> in
                let id = textID.value
                return self.isValidID(id)
            }
        
        let invalidID = isValidID.filter { isValid in isValid == false }
            .mapToVoid()
        
        invalidID
            .bind(onNext: { isGoodID.accept(false) })
            .disposed(by: disposeBag)
        
        // 중복 여부 확인
        let isDuplicateID = isValidID
            .filter { isValid in isValid == true }
            .flatMapLatest { _ -> Observable<Bool> in
                let id = textID.value
                return self.isDuplicateID(id: id)
            }
        
        let duplicateID = isDuplicateID
            .filter { isDuplicate in isDuplicate == true }
            .mapToVoid()
        
        isDuplicateID
            .bind(onNext: { isDuplicate in
                isGoodID.accept(!isDuplicate)
            })
            .disposed(by: disposeBag)
        
        let availableID = isGoodID
            .distinctUntilChanged()
            .filter { isGood in isGood == true }
            .mapToVoid()
        
        let unavailableID = isGoodID
            .distinctUntilChanged()
            .filter { isGood in isGood == false }
            .mapToVoid()
    
        let successLogin = input.btnDoneTapped
            .asObservable()
            .flatMapLatest { () -> BehaviorRelay<LoginInfo> in
                return self.loginInfo
            }
        
        return Output(editingID: editingID.asDriverOnErrorJustComplete(),
                      defaultID: defaultID.asDriverOnErrorJustComplete(),
                      invalidID: invalidID.asDriverOnErrorJustComplete(),
                      duplicateID: duplicateID.asDriverOnErrorJustComplete(),
                      availableID: availableID.asDriverOnErrorJustComplete(),
                      unavailableID: unavailableID.asDriverOnErrorJustComplete(),
                      successIDSetting: successLogin.asDriverOnErrorJustComplete()
        )
    }
}
extension IDSettingViewModel {
    func isValidID(_ id: String?) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let text = id {
                let pattern = "^[A-Za-z0-9]{0,}$"
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
    
    // TODO: Request isDuplicateID API
    func isDuplicateID(id: String?) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if id != nil {
                observer.onNext(false)
                observer.onCompleted()
            } else {
                observer.onNext(true)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
