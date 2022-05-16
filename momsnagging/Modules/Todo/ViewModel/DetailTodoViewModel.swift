//
//  DetailTodoViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/16.
//

import Foundation
import RxSwift
import RxCocoa

class DetailTodoViewModel: BaseViewModel {
    
    enum TextHintType: String {
        case empty      = "할일 이름은 필수로 입력해야 한단다"
        case invalid    = "할일 이름은 30글자를 넘길 수 없단다"
        case none       = ""
    }
    
    var disposeBag = DisposeBag()
    private let isNew: BehaviorRelay<Bool>
    
    init(isNew: Bool) {
        self.isNew = BehaviorRelay<Bool>(value: isNew)
    }
    
    // MARK: - Input
    struct Input {
        /// 더보기
        let btnMoreTapped: Driver<Void>
        let dimViewTapped: Driver<Void>
        let btnModifyTapped: Driver<Void>
        let btnDeleteTapped: Driver<Void>
        /// 뒤로 가기
        let btnBackTapped: Driver<Void>
        let backAlertDoneHandler: Driver<Void>
        /// 습관 이름
        let textName: Driver<String>
        let editingDidBeginName: Driver<Void>
        let editingDidEndName: Driver<Void>
        /// 수행 시간
        let btnPerformTimeTapped: Driver<Void>
        let textPerformTime: Driver<String?>
        /// 잔소리 설정
        let valueChangedPush: Driver<Bool>
        let valueChangedTimePicker: Driver<Date>
        /// 완료
        let btnDoneTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        /// 바텀 시트
        let showBottomSheet: Driver<Void>
        let hideBottomSheet: Driver<Void>
        /// 작성 모드
        let isWriting: Driver<Bool>
        /// 뒤로 가기
        let showBackAlert: Driver<String>
        let goToBack: Driver<Void>
        /// 이름 수정 중
        let isEditingName: Driver<Bool>
        /// 텍스트 힌트
        let textHint: Driver<TextHintType>
        /// '수행 시간 설정' 이동
        let goToPerformTimeSetting: Driver<Void>
        /// 잔소리 알림 여부
        let isNaggingPush: Driver<Bool>
        /// 잔소리 시간 선택
        let setTimeNaggingPush: Driver<Date?>
        /// 완료 가능
        let canBeDone: Driver<Bool>
        /// 할일 추가 완료
        let successDoneAddTodo: Driver<Void>
        /// 할일 수정 완료
        let successDoneModifyTodo: Driver<Void>
    }
        
    func transform(input: Input) -> Output {
        
        /// 작성 모드
        let isWriting = BehaviorRelay<Bool>(value: false)
        let isNew = self.isNew
        isNew
            .bind(onNext: {
                isWriting.accept($0)
            }).disposed(by: disposeBag)
        
        let btnModifyTapped = input.btnModifyTapped.asObservable().share()
        
        btnModifyTapped
            .subscribe(onNext: {
                isWriting.accept(true)
            }).disposed(by: disposeBag)
        
        let hideBottomSheet = Observable.merge(btnModifyTapped, input.dimViewTapped.asObservable())
        
        let showBackAlert = input.btnBackTapped
            .asObservable()
            .flatMapLatest { return Observable.just(STR_TODO_BACK) }
        
        /// 할일 이름
        let textName = BehaviorRelay<String>(value: "")
        let isEditingName = BehaviorRelay<Bool>(value: false)
        let textHint = BehaviorRelay<TextHintType>(value: .none)
        
        input.textName
            .drive(onNext: { text in
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
                    }.share()
        
        isEmptyName.filter({ $0 == true })
            .bind(onNext: { _ in
                textHint.accept(.empty)
            }).disposed(by: disposeBag)
        
        // 사용 가능 여부 확인 (띄어쓰기 포함 한/영/숫자/이모지 30글자)
        let isValidName = isEmptyName
            .filter({ $0 == false })
            .flatMapLatest { _ -> Observable<Bool> in
                let name = textName.value
                if name.count > 30 {
                    return Observable.just(false)
                }
                return Observable.just(true)
            }.share()
        
        isValidName
            .bind(onNext: { isValid in
                textHint.accept(isValid ? .none : .invalid)
            }).disposed(by: disposeBag)
        
        /// 수행 시간 설정
        let textPerformTime = BehaviorRelay<String>(value: "")
        
        input.textPerformTime
            .drive(onNext: { text in
                textPerformTime.accept(text ?? "")
            }).disposed(by: disposeBag)
        
        /// 잔소리 알림 설정
        let isNaggingPush = BehaviorRelay<Bool>(value: false)
        let timeNaggingPush = BehaviorRelay<Date?>(value: nil)
        
        input.valueChangedPush
            .drive(onNext: { isOn in
                isNaggingPush.accept(isOn)
            }).disposed(by: disposeBag)
        
        isNaggingPush
            .subscribe(onNext: { isOn in
                if !isOn {
                    timeNaggingPush.accept(nil)
                }
            }).disposed(by: disposeBag)
        
        input.valueChangedTimePicker
            .drive(onNext: { date in
                timeNaggingPush.accept(date)
            }).disposed(by: disposeBag)
        
        let canBeDone = Observable.combineLatest(isValidName.asObservable(), textPerformTime.asObservable(), isNaggingPush.asObservable(), timeNaggingPush.asObservable())
            .map({ isValidName, textPerformTime, isNaggingPush, timeNaggingPush -> Bool in
                if isValidName && !textPerformTime.isEmpty {
                    if !isNaggingPush {
                        return true
                    } else {
                        if timeNaggingPush != nil {
                            return true
                        }
                    }
                }
                return false
            })
        
        // TODO: Request 할일 추가 API
        let done = input.btnDoneTapped.asObservable().share()
        
        // 추가
        let successDoneAddTodo = done
            .flatMapLatest { () -> Observable<Bool> in
                return isNew.asObservable()
            }.filter { $0 == true }.mapToVoid().debug()
        
        // 수정
        let successDoneModifyTodo = done
            .flatMapLatest { () -> Observable<Bool> in
                return isNew.asObservable()
            }.filter { $0 == false }.mapToVoid().debug()
        
        successDoneModifyTodo
            .subscribe(onNext: {
                isWriting.accept(false)
            }).disposed(by: disposeBag)
     
        return Output(showBottomSheet: input.btnMoreTapped,
                      hideBottomSheet: hideBottomSheet.asDriverOnErrorJustComplete(),
                      isWriting: isWriting.asDriverOnErrorJustComplete(),
                      showBackAlert: showBackAlert.asDriver(onErrorJustReturn: STR_TODO_BACK),
                      goToBack: input.backAlertDoneHandler,
                      isEditingName: isEditingName.asDriverOnErrorJustComplete(),
                      textHint: textHint.asDriverOnErrorJustComplete(),
                      goToPerformTimeSetting: input.btnPerformTimeTapped,
                      isNaggingPush: isNaggingPush.asDriverOnErrorJustComplete(),
                      setTimeNaggingPush: timeNaggingPush.skip(1).distinctUntilChanged().asDriverOnErrorJustComplete(),
                      canBeDone: canBeDone.asDriverOnErrorJustComplete(),
                      successDoneAddTodo: successDoneAddTodo.asDriverOnErrorJustComplete(),
                      successDoneModifyTodo: successDoneModifyTodo.asDriverOnErrorJustComplete())
    }
    
}
