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
        case invalid    = "습관 이름은 11글자를 넘길 수 없단다"
        case none       = ""
    }
    
    var disposeBag = DisposeBag()
    var cycleWeek = Observable.of(["월", "화", "수", "목", "금", "토", "일"])
    var cycleNumber = Observable.of(["1", "2", "3", "4", "5", "6"])

    // MARK: - Input
    struct Input {
        let btnBackTapped: Driver<Void>
        /// 습관 이름
        let textName: Driver<String?>
        let editingDidBeginName: Driver<Void>
        let editingDidEndName: Driver<Void>
        /// 수행 시간
        let btnPerformTimeTapped: Driver<Void>
        /// 이행 주기
        let btnCycleWeekTapped: Driver<Void>
        let btnCycleNumber: Driver<Void>
        let cycleItemSelected: Driver<IndexPath>
        /// 잔소리 설정
        let valueChangedPush: Driver<Bool>
    }
    
    // MARK: - Output
    struct Output {
        /// 뒤로 가기
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
        /// 이행 주기 아이템 선택
        let cycleItemSelected: Driver<IndexPath>
        /// 잔소리 알림 여부
        let isNaggingPush: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let textName = BehaviorRelay<String>(value: "")
        let isEditingName = BehaviorRelay<Bool>(value: false)
        let textHint = BehaviorRelay<TextHintType>(value: .none)
        let cycleItems = BehaviorRelay<[String]>(value: [])
        let selectCycleType = BehaviorRelay<CycleType>(value: .week)
        let isNaggingPush = BehaviorRelay<Bool>(value: false)
        
        input.btnCycleWeekTapped
            .drive(onNext: { _ in
                selectCycleType.accept(.week)
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
        
        input.btnCycleNumber
            .asObservable()
            .flatMapLatest { () -> Observable<[String]> in
                return self.cycleNumber
            }.subscribe(onNext: { items in
                cycleItems.accept(items)
                selectCycleType.accept(.number)
            }).disposed(by: disposeBag)
        
        selectCycleType
            .filter { $0 == .week }
            .flatMapLatest { _ -> Observable<[String]> in
                return self.cycleWeek
            }.subscribe(onNext: { items in
                cycleItems.accept(items)
            }).disposed(by: disposeBag)
        
        selectCycleType
            .filter { $0 == .number }
            .flatMapLatest { _ -> Observable<[String]> in
                return self.cycleNumber
            }.subscribe(onNext: { items in
                cycleItems.accept(items)
            }).disposed(by: disposeBag)
        
        input.valueChangedPush
            .drive(onNext: { isOn in
                isNaggingPush.accept(isOn)
            }).disposed(by: disposeBag)
        
        return Output(goToBack: input.btnBackTapped,
                      isEditingName: isEditingName.asDriverOnErrorJustComplete(),
                      textHint: textHint.asDriverOnErrorJustComplete(),
                      goToPerformTimeSetting: input.btnPerformTimeTapped,
                      selectCycleType: selectCycleType.asDriverOnErrorJustComplete(),
                      cycleItems: cycleItems,
                      cycleItemSelected: input.cycleItemSelected,
                      isNaggingPush: isNaggingPush.asDriverOnErrorJustComplete())
    }
}
