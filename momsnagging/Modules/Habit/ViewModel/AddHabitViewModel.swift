//
//  AddHabitViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/07.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class AddHabitViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    var provider = MoyaProvider<ScheduleService>()

    var dateParam: String?
    var homeViewModel: HomeViewModel?
    
    init(dateParam: String, homeViewModel:HomeViewModel) {
        self.dateParam = dateParam
        self.homeViewModel = homeViewModel
    }
    
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
            
            self.provider.request(.recommendedHabitCategoryLookUp, completion: { res in
                switch res {
                case .success(let result):
                    do {
                        let json = JSON(try result.mapJSON())
                        Log.debug("getRecommendHabitTitle json", "\(json)")
                    } catch let error {
                        print("error : \(error)")
                    }
                case .failure(let error):
                    print("failure error : \(error)")
                }
            })
            
            var getRecommendHabitTitle = [RecommendHabitTitle]()
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "생활", normalColor: "FFECD6", highlightColor: "FDC685", image: Asset.Assets.recommendHabit1.image))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "운동", normalColor: "FFE8EA", highlightColor: "FAC0C5", image: Asset.Assets.recommendHabit2.image))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "성장", normalColor: "E4F2C6", highlightColor: "C5DE90", image: Asset.Assets.recommendHabit3.image))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "생산성", normalColor: "CDDCFA", highlightColor: "AAC0EB", image: Asset.Assets.recommendHabit4.image))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "식습관", normalColor: "F1E8FF", highlightColor: "D1C0EC", image: Asset.Assets.recommendHabit5.image))
            getRecommendHabitTitle.append(RecommendHabitTitle(title: "기타", normalColor: "CFFFF0", highlightColor: "95E0CA", image: Asset.Assets.recommendHabit6.image))
            
            observer.onNext(getRecommendHabitTitle)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
