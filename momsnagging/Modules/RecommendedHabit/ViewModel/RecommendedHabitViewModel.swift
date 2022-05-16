//
//  RecommendedHabitViewModel.swift
//  momsnagging
//
//  Created by 전창평 on 2022/05/10.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

class RecommendedHabitViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    var model = RecommendedHabitModel()
    
    var recommendHabitTitle: RecommendHabitTitle?
    var type: HabitType?
    
    var itemList = BehaviorRelay<[String]>(value: ["Item","Item","Item","Item","Item","Item","Item","Item","Item","Item"])
    
    enum HabitType {
        case life
        case productivity
        case workOut
        case eat
        case grow
        case etc
    }
    init(type: Int) {
        switch type {
        case 0:
            recommendHabitTitle?.title = "생활"
            self.type = .life
        case 1:
            recommendHabitTitle?.title = "생산성"
            self.type = .productivity
        case 2:
            recommendHabitTitle?.title = "운동"
            self.type = .workOut
        case 3:
            recommendHabitTitle?.title = "식습관"
            self.type = .eat
        case 4:
            recommendHabitTitle?.title = "성장"
            self.type = .grow
        case 5:
            recommendHabitTitle?.title = "기타"
            self.type = .etc
        default:
            break
        }
    }
    // MARK: - Input
    struct Input {
        
    }
    // MARK: - Output
    struct Output {
        var headTitle: BehaviorRelay<RecommendHabitTitle>?
    }
    
    func transform(input: Input) -> Output {
        let recommendHabitTitle = BehaviorRelay<RecommendHabitTitle>(value: RecommendHabitTitle())
        switch self.type {
        case .life:
            let habitTitle = RecommendHabitTitle(title: "생활", normalColor: "FFECD6", highlightColor: "FDC685")
            recommendHabitTitle.accept(habitTitle)
        case .productivity:
            let habitTitle = RecommendHabitTitle(title: "운동", normalColor: "FFE8EA", highlightColor: "FAC0C5")
            recommendHabitTitle.accept(habitTitle)
        case .workOut:
            let habitTitle = RecommendHabitTitle(title: "성장", normalColor: "E4F2C6", highlightColor: "C5DE90")
            recommendHabitTitle.accept(habitTitle)
        case .eat:
            let habitTitle = RecommendHabitTitle(title: "생산성", normalColor: "CDDCFA", highlightColor: "AAC0EB")
            recommendHabitTitle.accept(habitTitle)
        case .grow:
            let habitTitle = RecommendHabitTitle(title: "식습관", normalColor: "F1E8FF", highlightColor: "D1C0EC")
            recommendHabitTitle.accept(habitTitle)
        case .etc:
            let habitTitle = RecommendHabitTitle(title: "기타", normalColor: "CFFFF0", highlightColor: "95E0CA")
            recommendHabitTitle.accept(habitTitle)
        default:
            break
        }
        
        return Output(headTitle: recommendHabitTitle)
    }
    
}
// MARK: - API
extension RecommendedHabitViewModel {
    
}
