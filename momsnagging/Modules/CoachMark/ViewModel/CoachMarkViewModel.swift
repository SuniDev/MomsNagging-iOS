//
//  CoachMarkViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/05/30.
//

import Foundation
import RxSwift
import RxCocoa

class CoachMarkViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
        /// 뷰 진입
        let willAppearView: Driver<Void>
        /// 닫기 버튼
        let btnCloseTapped: Driver<Void>
        /// 다음 버튼
        let btnNextTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let goToMain: Driver<MainContainerViewModel>
        let setCoachMarkView: Driver<(Int, BaseViewModel)>
        let setCoachMarkIndex: Driver<Int>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        let coachMarkIndex = BehaviorRelay<Int>(value: 0)
        let coachMarkView = BehaviorRelay<(Int, BaseViewModel)>(value: (coachMarkIndex.value, self.getMainViewModel()))
        
        input.btnNextTapped
            .drive(onNext: {
                coachMarkIndex.accept(coachMarkIndex.value + 1)
            }).disposed(by: disposeBag)
        
        coachMarkIndex
            .filter({ $0 < 4 })
            .subscribe(onNext: { index in
                switch index {
                case 1: coachMarkView.accept((index, self.getAddHabitViewModel()))
                case 2: coachMarkView.accept((index, self.getDetailHabitViewModel()))
                case 3: coachMarkView.accept((index, self.getMainViewModel()))
                default: break
                }
            }).disposed(by: disposeBag)
                
        let goToMain = Observable.merge(
            input.btnCloseTapped.asObservable(),
            coachMarkIndex.filter({ $0 == 7 }).asObservable().mapToVoid())
            .map { _ -> MainContainerViewModel in
                Log.debug("goToMain")
                let viewModel = MainContainerViewModel()
                return viewModel
            }
        
        return Output(goToMain: goToMain.asDriverOnErrorJustComplete(),
                      setCoachMarkView: coachMarkView.asDriverOnErrorJustComplete(),
                      setCoachMarkIndex: coachMarkIndex.asDriverOnErrorJustComplete())
    }

}
extension CoachMarkViewModel {
    // TODO: 코치마크용 뷰모델
    private func getMainViewModel() -> MainContainerViewModel {
        return MainContainerViewModel()
    }
    
    private func getAddHabitViewModel() -> AddHabitViewModel {
        return AddHabitViewModel(dateParam: "", homeViewModel: HomeViewModel())
    }
    
    private func getDetailHabitViewModel() -> DetailHabitViewModel {
        return DetailHabitViewModel(isNew: true, isRecommendHabit: false, dateParam: "", homeViewModel: HomeViewModel())
    }
}