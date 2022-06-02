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
    
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }
    // MARK: - Input
    struct Input {
        let willApearView: Driver<Void>
        let btnCloseTapped: Driver<Void>
        let viewTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let setGrade: Driver<WeeklyEvaluationGrade>
        let dismiss: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let requestLastWeek = input.willApearView
            .asObservable()
            .flatMapLatest { _ -> Observable<GradeLastWeek> in
                return self.requestLastWeek()
            }.share()
        
        let setGrade = requestLastWeek
            .filter { $0.gradeLevel != nil }
            .map { $0.gradeLevel ?? -1 }
            .flatMapLatest { level -> Observable<WeeklyEvaluationGrade> in
                let grade = WeeklyEvaluationGrade(message: self.getNaggingMessage(gradeLevel: level), naggingLevel: CommonUser.naggingLevel, level: level)
                return Observable.just(grade)
            }
        
        let dismiss = Observable.merge(input.btnCloseTapped.asObservable(), input.viewTapped.asObservable()).share()
        dismiss
            .subscribe(onNext: { _ in
                Common.setUserDefaults(Date(), forKey: .dateLastCheckEvaluation)
            }).disposed(by: disposeBag)
        
        return Output(setGrade: setGrade.asDriverOnErrorJustComplete(),
                      dismiss: dismiss.asDriverOnErrorJustComplete())
    }
}
// MARK: - API
extension WeeklyEvaluationViewModel {
    private func requestLastWeek() -> Observable<GradeLastWeek> {
        let request = GradeLastWeekRequest()
        return self.provider.gradeService.lastWeek(request: request)
    }
    
    private func getNaggingMessage(gradeLevel: Int) -> String {
        let naggingLevel = CommonUser.naggingLevel
        
        if naggingLevel == .fondMom {
            switch gradeLevel {
            case 1: return "우리 \(CommonUser.nickName ?? "자식"),\n100점 만점에 100점~^^"
            case 2: return "내새끼~너무 잘했어!\n엄마가 항상 응원해^^"
            case 3: return "노력하는 사람이 제일 멋진거\n알지~?ㅎㅎ 엄마가 사랑해"
            case 4, 5: return "엄마는 우리 \(CommonUser.nickName ?? "자식")는\n건강하기만 하면 돼~^^고생했어\n오늘도 화이팅!"
            default:
                break
            }
        } else if naggingLevel == .coolMom {
            switch gradeLevel {
            case 1: return "잘했네. 지금처럼만 해."
            case 2: return "그래. 잘 봤다."
            case 3: return "조금 아쉽긴하지만, 수고 많았어."
            case 4, 5: return "이번주 용돈 없다."
            default:
                break
            }
        } else {
            switch gradeLevel {
            case 1: return "이번엔 쫌 잘했네! 이렇게 잘할 줄\n알았으면 진작부터 잘하지!\n할 수 있는데 왜그랬던거야?"
            case 2: return "엄마가 항상 말했지.\n너는 항상 몇개씩 빼놓더라?"
            case 3: return "이거 보고 느낀점 없니?"
            case 4, 5: return "너는 정말 애가 왜그러니?\n나중에 커서 뭐가 되려고 그래?"
            default:
                break
            }
        }
        return "수고했어요."
    }
}
// MARK: - Model
struct WeeklyEvaluationGrade {
    let message: String
    let naggingLevel: NaggingLevel
    let level: Int
}
