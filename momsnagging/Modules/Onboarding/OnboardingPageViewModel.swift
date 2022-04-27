//
//  OnboardingPageViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/24.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardingPageViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    override init() {
    }
    
    // MARK: - Input
    struct Input {
        let appendPage: Observable<Void>
    }
    
    // MARK: - Output
    struct Output {
        let setPageItemViewModel: Driver<OnboardingItemViewModel>
        let appendFirstPage: Driver<Void>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        let cntPage = BehaviorRelay<Int>(value: 0)
        
        let getDatas = self.getOnboardDatas()
                        
        let onboardingPageItemViewModel = getDatas
            .flatMapLatest { data -> Observable<OnboardingItemViewModel> in
                return self.onboardingPageItemViewModel(data: data)
            }
        
        input.appendPage
            .take(1)
            .bind(onNext: { _ in
                cntPage.accept(cntPage.value + 1)
            }).disposed(by: disposeBag)
        
        let appendFirstPage = cntPage.filter { cnt in cnt == 1 }.mapToVoid()
                
        return Output(setPageItemViewModel: onboardingPageItemViewModel.asDriverOnErrorJustComplete(),
                      appendFirstPage: appendFirstPage.asDriverOnErrorJustComplete())
    }
}

extension OnboardingPageViewModel {
    
    func getOnboardDatas() -> Observable<Onboarding> {
        return Observable<Onboarding>.create { observer -> Disposable in
            observer.onNext(Onboarding(0))
            observer.onNext(Onboarding(1))
            observer.onNext(Onboarding(2))
            observer.onNext(Onboarding(3))
            observer.onNext(Onboarding(4))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func onboardingPageItemViewModel(data: Onboarding) -> Observable<OnboardingItemViewModel> {
        return Observable<OnboardingItemViewModel>.create { observer -> Disposable in
            let viewModel = OnboardingItemViewModel(data: data)
            observer.onNext(viewModel)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
