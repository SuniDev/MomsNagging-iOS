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
        /// 사용 가능 호칭 (아들 OR 딸)
        let availableName: Driver<Void>
        /// 사용 가능 호칭 (커스텀 이름)
        let availableCustomName: Driver<Void>
        /// 사용 불가 호칭 (커스텀 이름)
        let unavailableCustomName: Driver<Void>
        /// 호칭 설정 완료
        let successNameSetting: Driver<LoginInfo>
    }
    
    func transform(input: Input) -> Output {
        let selectedNicknameType = BehaviorRelay<NicknameType>(value: .none)
        let textName = BehaviorRelay<String>(value: "")
        let isEditingName = BehaviorRelay<Bool>(value: false)
        let isEmptyName = BehaviorRelay<Bool>(value: true)
        let isGoodName = PublishRelay<Bool>()
        let isGoodCustomName = PublishRelay<Bool>()
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
        
        textName
            .bind { text in
                isEmptyName.accept(text.isEmpty)
            }.disposed(by: disposeBag)
        
        selectedNicknameType
            .distinctUntilChanged()
            .filter({ $0 != .none })
            .bind(onNext: { type in
                if type == .son || type == .daughter {
                    isGoodName.accept(true)
                    confirmName.accept(type.rawValue)
                } else {
                    textName.accept("")
                    isGoodName.accept(false)
                }
            }).disposed(by: disposeBag)
        
        let isHiddenTfName = selectedNicknameType
            .distinctUntilChanged()
            .filter({ $0 != .none })
            .flatMapLatest({ type -> Observable<Bool> in
                return Observable.just(type != .etc)
            })
            .distinctUntilChanged()
        
        input.textName
            .drive(onNext: { text in
                let text = text ?? ""
                textName.accept(text)
            }).disposed(by: disposeBag)
        
        input.editingDidBeginName
            .drive(onNext: { () in
                isEditingName.accept(true)
            }).disposed(by: disposeBag)
        
        input.editingDidEndName
            .drive(onNext: { () in
                isEditingName.accept(false)
                textName.accept(textName.value)
            }).disposed(by: disposeBag)
        
        let editingName = isEditingName
            .filter { isEditing in  isEditing == true }
            .mapToVoid()
                
        let defaultName = isEmptyName
            .filter({ $0 == true })
            .mapToVoid()
            .do(onNext: { _ in  confirmName.accept("") })
                
        let checkDefaultName = input.editingDidEndName
            .asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                Observable.just(isEmptyName.value)
            }
        
        // 사용 가능 여부 확인 (띄어쓰기 포함 한/영/숫자 1-10글자)
        checkDefaultName
            .filter { isEmpty in isEmpty == false }
            .flatMapLatest { _ -> Observable<Bool> in
                let name = textName.value
                return self.isValidName(name)
            }.bind(onNext: { isValid in isGoodCustomName.accept(isValid) })
            .disposed(by: disposeBag)
                    
        let availableName = isGoodName
            .filter { isGood in isGood == true }
            .mapToVoid()
                
        let availableCustomName = isGoodCustomName
            .filter { isGood in isGood == true }
            .do(onNext: { _ in
                confirmName.accept(textName.value)
            }).mapToVoid()
        
        let unavailableCustomName = isGoodCustomName
            .filter { isGood in isGood == false }
            .do(onNext: { _ in confirmName.accept("") })
            .mapToVoid()
    
        // TODO: Request 호칭 설정 API
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
            availableCustomName: availableCustomName.asDriverOnErrorJustComplete(),
            unavailableCustomName: unavailableCustomName.asDriverOnErrorJustComplete(),
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
