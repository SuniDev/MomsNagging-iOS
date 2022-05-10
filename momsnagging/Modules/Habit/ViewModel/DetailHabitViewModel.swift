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
    
    var disposeBag = DisposeBag()
    var cycleWeek = Observable.of(["월", "화", "수", "목", "금", "토", "일"])
    var cycleNumber = Observable.of(["1", "2", "3", "4", "5", "6"])

    // MARK: - Input
    struct Input {
        let btnBackTapped: Driver<Void>
        let btnCycleWeekTapped: Driver<Void>
        let btnCycleNumber: Driver<Void>
        let cycleItemSelected: Driver<IndexPath>
        let valueChangedPush: Driver<Bool>
    }
    
    // MARK: - Output
    struct Output {
        /// 뒤로 가기
        let goToBack: Driver<Void>
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
        
        let cycleItems = BehaviorRelay<[String]>(value: [])
        let selectCycleType = BehaviorRelay<CycleType>(value: .week)
        let isNaggingPush = BehaviorRelay<Bool>(value: false)
        
        input.btnCycleWeekTapped
            .drive(onNext: { _ in
                selectCycleType.accept(.week)
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
                      selectCycleType: selectCycleType.asDriverOnErrorJustComplete(),
                      cycleItems: cycleItems,
                      cycleItemSelected: input.cycleItemSelected,
                      isNaggingPush: isNaggingPush.asDriverOnErrorJustComplete())
    }
}
