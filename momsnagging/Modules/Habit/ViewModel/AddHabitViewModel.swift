//
//  AddHabitViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/07.
//

import Foundation
import RxSwift
import RxCocoa

class AddHabitViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
        let willAppearAddHabit: Driver<Void>
        let btnBackTapped: Driver<Void>
        let btnMyOwnHabitTapped: Driver<Void>
        let btnTipTapped: Driver<Void>
        let recommendTitleItemSelected: Driver<IndexPath>
    }
    
    // MARK: - Output
    struct Output {
        /// 뒤로 가기
        let goToBack: Driver<Void>
        /// 나만의 습관 만들기
        let goToMyOwnHabit: Driver<Void>
        /// 추천 습관 팁뷰
        let isHiddenTip: Driver<Bool>
        /// 추천 습관 개수
        let cntRecommendTitle: Driver<Int>
        /// 추천 습관 아이템
        let recommendTitleItems: BehaviorRelay<[RecommendHabitTitle]>
        /// 추천 습관 선택
        let recommendTitleItemSelected: Driver<IndexPath>
    }
    
    func transform(input: Input) -> Output {
        let recommendTitleItems = BehaviorRelay<[RecommendHabitTitle]>(value: [])
        let isHiddenTip = BehaviorRelay<Bool>(value: true)
        
        input.willAppearAddHabit
            .asObservable()
            .flatMapLatest { () -> Observable<[RecommendHabitTitle]> in
                return self.getRecommendHabitTitle()
            }.subscribe(onNext: { items in
                recommendTitleItems.accept(items)
            }).disposed(by: disposeBag)
        
        let cntRecommendTitle = recommendTitleItems
            .map { return $0.count }
        
        input.btnTipTapped
            .drive(onNext: {
                isHiddenTip.accept(!isHiddenTip.value)
            }).disposed(by: disposeBag)
        
        return Output(
            goToBack: input.btnBackTapped,
            goToMyOwnHabit: input.btnMyOwnHabitTapped,
            isHiddenTip: isHiddenTip.asDriver(onErrorJustReturn: true),
            cntRecommendTitle: cntRecommendTitle.asDriver(onErrorJustReturn: 0),
            recommendTitleItems: recommendTitleItems,
            recommendTitleItemSelected: input.recommendTitleItemSelected
        )
    }
}
extension AddHabitViewModel {
    // TODO: Request Recommend Habit Title API
    func getRecommendHabitTitle() -> Observable<[RecommendHabitTitle]> {
        return Observable<[RecommendHabitTitle]>.create { observer -> Disposable in
            var getRecommendHabitTitle = [RecommendHabitTitle]()
            
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "생활", normalColor: "FFECD6", highlightColor: "FDC685"))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "운동", normalColor: "FFE8EA", highlightColor: "FAC0C5"))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "성장", normalColor: "E4F2C6", highlightColor: "C5DE90"))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "생산성", normalColor: "CDDCFA", highlightColor: "AAC0EB"))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "식습관", normalColor: "F1E8FF", highlightColor: "D1C0EC"))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "기타", normalColor: "CFFFF0", highlightColor: "95E0CA"))
            
            observer.onNext(getRecommendHabitTitle)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
