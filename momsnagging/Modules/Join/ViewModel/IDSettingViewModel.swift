//
//  IDSettingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/28.
//

import Foundation
import RxSwift
import RxCocoa

class IDSettingViewModel: ViewModel, ViewModelType {
    
    enum TextHintType: String {
        case invalid    = "아이디에는 영어/숫자 4-15글자로 만들 수 있단다!"
        case duplicate  = "이미 사용중인 아이디란다."
        case succes     = "그것 참 좋은 아이디구나!"
        case none       = ""
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
        let textID: Driver<String?>
        let editingDidBeginID: Driver<Void>
        let editingDidEndID: Driver<Void>
        let btnDoneTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 뒤로 가기
        let goToBack: Driver<Void>
        /// 아이디 수정 중
        let isEditingID: Driver<Bool>
        /// 텍스트 힌트
        let textHint: Driver<TextHintType>
        /// 사용 가능 아이디
        let isAvailableID: Driver<Bool>
        /// 아이디 설정 완료 -> 호칭 설정 이동
        let goToNicknameSetting: Driver<NicknameSettingViewModel>
    }
    
    func transform(input: Input) -> Output {
        
        let textID = BehaviorRelay<String>(value: "")
        let isEditingID = BehaviorRelay<Bool>(value: false)
        let textHint = BehaviorRelay<TextHintType>(value: .none)
        let isAvailableID = BehaviorRelay<Bool>(value: false)
        
        input.textID
            .drive(onNext: { text in
                let text = text ?? ""
                textID.accept(text)
            }).disposed(by: disposeBag)
        
        input.editingDidBeginID
            .drive(onNext: { () in
                textHint.accept(.none)
                isEditingID.accept(true)
            }).disposed(by: disposeBag)
        
        input.editingDidEndID
            .drive(onNext: { () in
                isEditingID.accept(false)
                textID.accept(textID.value)
            }).disposed(by: disposeBag)
        
        let isEmptyID = input.editingDidEndID
            .asObservable()
            .flatMapLatest { _ -> Observable<Bool> in
                Observable.just(textID.value.isEmpty)
            }
        
        isEmptyID.filter({ $0 == true })
            .bind(onNext: { _ in
                textHint.accept(.none)
            }).disposed(by: disposeBag)
        
        // 사용 가능 여부 확인 (영어, 숫자만 가능)
        let isValidID = isEmptyID
            .filter({ $0 == false })
            .flatMapLatest { _ -> Observable<Bool> in
                let id = textID.value
                return self.isValidID(id)
            }
        
        isValidID
            .filter({ $0 == false })
            .bind(onNext: { _ in
                textHint.accept(.invalid)
            }).disposed(by: disposeBag)
                
        // 중복 여부 확인
        let isDuplicateID = isValidID
            .filter({ $0 == true })
            .flatMapLatest { _ -> Observable<Bool> in
                let id = textID.value
                return self.isDuplicateID(id: id)
            }
        
        isDuplicateID
            .bind(onNext: { isDuplicate in
                textHint.accept(isDuplicate ? .duplicate : .succes)
            }).disposed(by: disposeBag)
        
        textHint
            .bind(onNext: { type in
                switch type {
                case .succes: isAvailableID.accept(true)
                case .none, .duplicate, .invalid : isAvailableID.accept(false)
                }
            }).disposed(by: disposeBag)
                        
        let goToNicknameSetting = input.btnDoneTapped
            .asObservable()
            .flatMapLatest { () -> BehaviorRelay<SNSLogin> in
                return self.snsLogin
            }.map { info -> NicknameSettingViewModel in
                let viewModel = NicknameSettingViewModel(withService: self.provider, snsLogin: info)
                return viewModel
            }
        
        return Output(goToBack: input.btnBackTapped,
                      isEditingID: isEditingID.asDriverOnErrorJustComplete(),
                      textHint: textHint.asDriverOnErrorJustComplete(),
                      isAvailableID: isAvailableID.asDriverOnErrorJustComplete(),
                      goToNicknameSetting: goToNicknameSetting.asDriverOnErrorJustComplete()
        )
    }
}
extension IDSettingViewModel {
    func isValidID(_ id: String?) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            if let text = id {
                let pattern = "^[A-Za-z0-9]{4,15}$"
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
