//
//  DetailHabitViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/06.
//

import Foundation
import RxSwift
import RxCocoa

class DetailHabitViewModel: BaseViewModel, ViewModelType {
    
    enum CycleType: String {
        case week = "요일"
        case number = "N회"
    }
    
    enum TextHintType: String {
        case empty      = "습관 이름은 필수로 입력해야 한단다"
        case invalid    = "습관 이름은 30글자를 넘길 수 없단다"
        case none       = ""
    }
    
    var disposeBag = DisposeBag()
    private let isNew: BehaviorRelay<Bool>
    private let isRecommendHabit: BehaviorRelay<Bool>
    private var cycleWeek = BehaviorRelay<[String]>(value: ["월", "화", "수", "목", "금", "토", "일"])
    private var cycleNumber = BehaviorRelay<[String]>(value: ["1", "2", "3", "4", "5", "6"])
    
    init(isNew: Bool, isRecommendHabit: Bool) {
        self.isNew = BehaviorRelay<Bool>(value: isNew)
        self.isRecommendHabit = BehaviorRelay<Bool>(value: isRecommendHabit)
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
        /// 이행 주기
        let btnCycleWeekTapped: Driver<Void>
        let btnCycleNumber: Driver<Void>
        let cycleModelSelected: Driver<String>
        let cycleModelDeselected: Driver<String>
        /// 잔소리 설정
        let valueChangedPush: Driver<Bool>
        let valueChangedTimePicker: Driver<Date>
        /// 완료
        let btnDoneTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        ///  바텀 시트
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
        /// 이행 주기 선택
        let selectCycleType: Driver<CycleType>
        /// 이행 주기 아이템
        let cycleItems: BehaviorRelay<[String]>
        /// 잔소리 알림 여부
        let isNaggingPush: Driver<Bool>
        /// 잔소리 시간 선택
        let setTimeNaggingPush: Driver<Date?>
        /// 완료 가능
        let canBeDone: Driver<Bool>
        /// 습관 추가 완료
        let successDoneAddHabit: Driver<Void>
        /// 습관 수정 완료
        let successDoneModifyHabit: Driver<Void>
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
        
        /// 습관 이름
        let textName = BehaviorRelay<String>(value: "")
        let isEditingName = BehaviorRelay<Bool>(value: false)
        let textHint = BehaviorRelay<TextHintType>(value: .none)
        
        let showBackAlert = input.btnBackTapped
            .asObservable()
            .flatMapLatest { return Observable.just(STR_ADD_HABIT_BACK) }
        
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
        
        /// 이행 주기
        let selectCycleType = BehaviorRelay<CycleType>(value: .week)
        let cycleItems = BehaviorRelay<[String]>(value: [])
        let selectedCycleItems = BehaviorRelay<[String]>(value: [])
        
        input.btnCycleWeekTapped
            .drive(onNext: { _ in
                selectCycleType.accept(.week)
            }).disposed(by: disposeBag)
        
        input.btnCycleNumber
            .drive(onNext: { _ in
                selectCycleType.accept(.number)
            }).disposed(by: disposeBag)
        
        selectCycleType
            .distinctUntilChanged()
            .filter { $0 == .week }
            .flatMapLatest { _ -> Observable<[String]> in
                return self.cycleWeek.asObservable()
            }.subscribe(onNext: { items in
                cycleItems.accept(items)
                selectedCycleItems.accept([])
            }).disposed(by: disposeBag)
        
        selectCycleType
            .distinctUntilChanged()
            .filter { $0 == .number }
            .flatMapLatest { _ -> Observable<[String]> in
                return self.cycleNumber.asObservable()
            }.subscribe(onNext: { items in
                cycleItems.accept(items)
                selectedCycleItems.accept([])
            }).disposed(by: disposeBag)
        
        input.cycleModelSelected
            .drive(onNext: { item in
                var selectedItems = selectedCycleItems.value
                
                if !selectedItems.contains(obj: item) {
                    selectedItems.append(item)
                    let items: [String] = selectedItems
                    Log.debug("selectedItems ", items)
                    selectedCycleItems.accept(items)
                }
            }).disposed(by: disposeBag)
        
        input.cycleModelDeselected
            .drive(onNext: { item in
                let selectedItems = selectedCycleItems.value
                selectedCycleItems.accept(selectedItems.removed(item))
                Log.debug("selectedItems ", selectedCycleItems.value)
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
        
        let canBeDone = Observable.combineLatest(isValidName.asObservable(), textPerformTime.asObservable(), selectedCycleItems.asObservable(), isNaggingPush.asObservable(), timeNaggingPush.asObservable())
            .map({ isValidName, textPerformTime, selectedCycleItems, isNaggingPush, timeNaggingPush -> Bool in
                if isValidName && !textPerformTime.isEmpty && !selectedCycleItems.isEmpty {
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
        
        // TODO: Request 습관 추가 API
        let done = input.btnDoneTapped.asObservable().share()
        
        // 추가
        let successDoneAddHabit = done
            .flatMapLatest { () -> Observable<Bool> in
                return isNew.asObservable()
            }.filter { $0 == true }.mapToVoid().debug()
        
        // 수정
        let successDoneModifyHabit = done
            .flatMapLatest { () -> Observable<Bool> in
                return isNew.asObservable()
            }.filter { $0 == false }.mapToVoid().debug()
        
        successDoneModifyHabit
            .subscribe(onNext: {
                isWriting.accept(false)
            }).disposed(by: disposeBag)

        return Output(showBottomSheet: input.btnMoreTapped,
                      hideBottomSheet: hideBottomSheet.asDriverOnErrorJustComplete(),
                      isWriting: isWriting.asDriverOnErrorJustComplete(),
                      showBackAlert: showBackAlert.asDriver(onErrorJustReturn: STR_ADD_HABIT_BACK),
                      goToBack: input.backAlertDoneHandler,
                      isEditingName: isEditingName.asDriverOnErrorJustComplete(),
                      textHint: textHint.asDriverOnErrorJustComplete(),
                      goToPerformTimeSetting: input.btnPerformTimeTapped,
                      selectCycleType: selectCycleType.asDriverOnErrorJustComplete(),
                      cycleItems: cycleItems,
                      isNaggingPush: isNaggingPush.asDriverOnErrorJustComplete(),
                      setTimeNaggingPush: timeNaggingPush.skip(1).distinctUntilChanged().asDriverOnErrorJustComplete(),
                      canBeDone: canBeDone.asDriverOnErrorJustComplete(),
                      successDoneAddHabit: successDoneAddHabit.asDriverOnErrorJustComplete(),
                      successDoneModifyHabit: successDoneModifyHabit.asDriverOnErrorJustComplete()
        )
    }
}
