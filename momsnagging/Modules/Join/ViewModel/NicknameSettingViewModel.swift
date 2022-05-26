//
//  NicknameSettingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/30.
//

import UIKit
import RxSwift
import RxCocoa

class NicknameSettingViewModel: ViewModel, ViewModelType {
        
    enum NicknameType: String {
        case son = "아들!"
        case daughter = "딸!"
        case custom = ""
        case none
    }

    enum TextHintType: String {
        case success = "그것 참 재밌는 호칭이구나!"
        case error = "다른 이름을 생각해보겠니?"
        case none = ""
    }
    
    var disposeBag = DisposeBag()
    
    private let snsLogin: BehaviorRelay<SNSLogin>
    
    // MARK: - init
    init(withService provider: AppServices, snsLogin: SNSLogin) {
        self.snsLogin = BehaviorRelay<SNSLogin>(value: snsLogin)
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        let btnBackTapped: Driver<Void>
        let btnSonTapped: Driver<Void>
        let btnDaughterTapped: Driver<Void>
        let btnCustomTapped: Driver<Void>
        let textName: Driver<String?>
        let editingDidBeginName: Driver<Void>
        let editingDidEndName: Driver<Void>
        let btnDoneTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 뒤로 가기
        let goToBack: Driver<Void>
        /// 호칭 타입 선택
        let selectedNicknameType: Driver<NicknameType>
        /// 이름 확인
        let confirmName: Driver<String>
        /// 이름 수정 중
        let isEditingName: Driver<Bool>
        /// 텍스트 힌트
        let textHint: Driver<TextHintType>
        /// 사용 가능 아이디
        let isAvailableName: Driver<Bool>
        /// 호칭 설정 완료
        let successNameSetting: Driver<SNSLogin>
    }
    
    func transform(input: Input) -> Output {
        let selectedNicknameType = BehaviorRelay<NicknameType>(value: .none)
        let textName = BehaviorRelay<String>(value: "")
        let isEditingName = BehaviorRelay<Bool>(value: false)
        let confirmName = BehaviorRelay<String>(value: "")
        let textHint = BehaviorRelay<TextHintType>(value: .none)
        let isAvailableName = BehaviorRelay<Bool>(value: false)
        
        input.btnSonTapped
            .drive(onNext: { _ in
                selectedNicknameType.accept(.son)
            }).disposed(by: disposeBag)
        
        input.btnDaughterTapped
            .drive(onNext: { _ in
                selectedNicknameType.accept(.daughter)
            }).disposed(by: disposeBag)
        
        input.btnCustomTapped
            .drive(onNext: { _ in
                selectedNicknameType.accept(.custom)
            }).disposed(by: disposeBag)
        
        selectedNicknameType
            .distinctUntilChanged()
            .filter({ $0 != .none })
            .bind(onNext: { type in
                isAvailableName.accept(type == .son || type == .daughter)
                confirmName.accept(type.rawValue)
            }).disposed(by: disposeBag)
        
        input.textName
            .drive(onNext: { text in
                let text = text ?? ""
                textName.accept(text)
            }).disposed(by: disposeBag)
        
        input.editingDidBeginName
            .drive(onNext: { () in
                textHint.accept(.none)
                isEditingName.accept(true)
            }).disposed(by: disposeBag)
        
        input.editingDidEndName
            .drive(onNext: { () in
                isEditingName.accept(false)
                textName.accept(textName.value)
            }).disposed(by: disposeBag)
        
        let isEmptyName = input.editingDidEndName
                    .asObservable()
                    .flatMapLatest { _ -> Observable<Bool> in
                        Observable.just(textName.value.isEmpty)
                    }
        
        isEmptyName.filter({ $0 == true })
            .bind(onNext: { _ in
                confirmName.accept("")
                textHint.accept(.none)
            }).disposed(by: disposeBag)
        
        // 사용 가능 여부 확인 (띄어쓰기 포함 한/영/숫자 1-10글자)
        let isValidName = isEmptyName
            .filter({ $0 == false })
            .flatMapLatest { _ -> Observable<Bool> in
                let name = textName.value
                return self.isValidName(name)
            }
        
        isValidName
            .bind(onNext: { isValid in
                textHint.accept(isValid ? .success : .error)
                confirmName.accept(isValid ? textName.value : "")
            }).disposed(by: disposeBag)
                
        textHint
            .bind(onNext: { type in
                switch type {
                case .success: isAvailableName.accept(true)
                case .none, .error: isAvailableName.accept(false)
                }
            }).disposed(by: disposeBag)

        // TODO: Request 호칭 설정 API
        let successNameSetting = input.btnDoneTapped
            .asObservable()
            .flatMapLatest { () -> BehaviorRelay<SNSLogin> in
                return self.snsLogin
            }
        
        return Output(
            goToBack: input.btnBackTapped,
            selectedNicknameType: selectedNicknameType.asDriverOnErrorJustComplete(),
            confirmName: confirmName.asDriverOnErrorJustComplete(),
            isEditingName: isEditingName.asDriverOnErrorJustComplete(),
            textHint: textHint.asDriverOnErrorJustComplete(),
            isAvailableName: isAvailableName.asDriverOnErrorJustComplete(),
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
