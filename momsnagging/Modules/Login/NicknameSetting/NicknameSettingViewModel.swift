//
//  NicknameSettingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/30.
//

import UIKit
import RxSwift
import RxCocoa

enum NicknameType: String {
    case son = "아들!"
    case daughter = "딸!"
    case etc = ""
    case none
}

class NicknameSettingViewModel: BaseViewModel, ViewModelType {
        
    var disposeBag = DisposeBag()
    private let loginInfo: BehaviorRelay<LoginInfo>
    
    init(loginInfo: LoginInfo) {
        self.loginInfo = BehaviorRelay<LoginInfo>(value: loginInfo)
    }
    
    // MARK: - Input
    struct Input {
        let btnSonTapped: Driver<Void>
        let btnDaughterTapped: Driver<Void>
        let btnEtcTapped: Driver<Void>
        let textName: Driver<String?>
        let editingDidBeginName: Driver<Void>
        let editingDidEndName: Driver<Void>
        let btnDoneTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 호칭 타입 선택
        let selectedNicknameType: Driver<NicknameType>
        /// 텍스트필드 숨김/보임
        let isHiddenTfName: Driver<Bool>
        /// 이름 확인
        let confirmName: Driver<String>
        /// 이름 수정 중
        let editingName: Driver<Void>
        /// 디폴트 상태
        let defaultName: Driver<Void>
        /// 사용 가능 호칭
        let availableName: Driver<Void>
        /// 사용 불가 호칭
        let unavailableName: Driver<Void>
        /// 호칭 설정 완료
        let successNameSetting: Driver<LoginInfo>
    }
    
    func transform(input: Input) -> Output {
        let selectedNicknameType = BehaviorRelay<NicknameType>(value: .none)
        let textName = BehaviorRelay<String>(value: "")
        let isEditingName = BehaviorRelay<Bool>(value: false)
        let isEmptyName = BehaviorRelay<Bool>(value: false)
//        let isGoodName = BehaviorRelay<Bool>(value: false)
        let isGoodName = PublishRelay<Bool>()
        let confirmName = BehaviorRelay<String>(value: "")
        
        input.btnSonTapped
            .drive(onNext: { _ in
                selectedNicknameType.accept(.son)
            }).disposed(by: disposeBag)
        
        input.btnDaughterTapped
            .drive(onNext: { _ in
                selectedNicknameType.accept(.daughter)
            }).disposed(by: disposeBag)
        
        input.btnEtcTapped
            .drive(onNext: { _ in
                selectedNicknameType.accept(.etc)
            }).disposed(by: disposeBag)
        
        let isHiddenTfName = selectedNicknameType
            .distinctUntilChanged()
            .filter({ $0 != .none })
            .do(onNext: { type in
                confirmName.accept(type.rawValue)
                isGoodName.accept(type != .etc)
            })
            .flatMapLatest({ type -> Observable<Bool> in
                return type == .etc ? Observable.just(false) : Observable.just(true)
            })
            .distinctUntilChanged()
        
        input.textName
            .drive(onNext: { text in
                let text = text ?? ""
                textName.accept(text)
                isEmptyName.accept(text.isEmpty)
            }).disposed(by: disposeBag)
        
        input.editingDidBeginName
            .drive(onNext: { () in
                isEditingName.accept(true)
                isGoodName.accept(false)
            }).disposed(by: disposeBag)
        
        input.editingDidEndName
            .drive(onNext: { () in
                isEditingName.accept(false)
            }).disposed(by: disposeBag)
        
        let editingName = isEditingName
            .filter { isEditing in  isEditing == true }
            .mapToVoid()
        
        let isDefaultName = input.editingDidEndName
            .asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                Observable.just(isEmptyName.value)
            }
        
        let defaultName = isDefaultName
            .filter { isDefault in isDefault == true }
            .mapToVoid()
        
        // 사용 가능 여부 확인 (띄어쓰기 포함 한/영/숫자 1-10글자)
        isDefaultName
            .filter { isDefault in isDefault == false }
            .flatMapLatest { _ -> Observable<Bool> in
                let name = textName.value
                return self.isValidName(name)
            }.bind(onNext: { isValid in isGoodName.accept(isValid) })
            .disposed(by: disposeBag)
                    
        let availableName = isGoodName
            .distinctUntilChanged()
            .filter { isGood in isGood == true }
            .do(onNext: { _ in confirmName.accept(textName.value) })
            .mapToVoid()
        
        let unavailableName = isGoodName
            .distinctUntilChanged()
            .filter { isGood in isGood == false }
            .do(onNext: { _ in confirmName.accept("") })
            .mapToVoid()
    
        let successNameSetting = input.btnDoneTapped
            .asObservable()
            .flatMapLatest { () -> BehaviorRelay<LoginInfo> in
                return self.loginInfo
            }
        
        return Output(
            selectedNicknameType: selectedNicknameType.asDriverOnErrorJustComplete(),
            isHiddenTfName: isHiddenTfName.asDriverOnErrorJustComplete(),
            confirmName: confirmName.asDriverOnErrorJustComplete(),
            editingName: editingName.asDriverOnErrorJustComplete(),
            defaultName: defaultName.asDriverOnErrorJustComplete(),
            availableName: availableName.asDriverOnErrorJustComplete(),
            unavailableName: unavailableName.asDriverOnErrorJustComplete(),
            successNameSetting: successNameSetting.asDriverOnErrorJustComplete())
    }
    
}
extension NicknameSettingViewModel {
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
