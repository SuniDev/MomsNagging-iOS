//
//  WeeklyEvaluationViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/06/03.
//

import Foundation
import RxSwift
import RxCocoa

class WeeklyEvaluationViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    private let gradeData: BehaviorRelay<WeeklyEvaluationGrade>
    
    // MARK: - init
    init(withService provider: AppServices, gradeData: WeeklyEvaluationGrade) {
        self.gradeData = BehaviorRelay<WeeklyEvaluationGrade>(value: gradeData)
        super.init(provider: provider)
    }
    // MARK: - Input
    struct Input {
        let btnCloseTapped: Driver<Void>
        let viewTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let setGrade: Driver<WeeklyEvaluationGrade>
        let dismiss: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let setGrade = self.gradeData
        
        let dismiss = Observable.merge(input.btnCloseTapped.asObservable(), input.viewTapped.asObservable())
        
        return Output(setGrade: setGrade.asDriverOnErrorJustComplete(),
                      dismiss: dismiss.asDriverOnErrorJustComplete())
    }
}

// MARK: - Model
struct WeeklyEvaluationGrade {
    let message: String
    let naggingLevel: NaggingLevel
    let level: Int
}
