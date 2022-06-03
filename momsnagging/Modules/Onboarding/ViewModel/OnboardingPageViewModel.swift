//
//  OnboardingPageViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/24.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardingPageViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        let currentPageIndex: Driver<Int>
        let btnLoginTapped: Driver<Void>
        let btnNextTapped: Driver<Void>
        let btnStartTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let setPageItemViewModel: Driver<OnboardingItemViewModel>
        let appendFirstPage: Driver<Void>
        let isLastPage: Driver<Bool>
        let goToLogin: Driver<LoginViewModel>
        let goToNextPage: Driver<Void>
        let goToMain: Driver<Void>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        let cntPage = BehaviorRelay<Int>(value: 0)
        
        let getDatas = self.getOnboardDatas()
                        
        let onboardingPageItemViewModel = getDatas
            .flatMapLatest { data -> Observable<OnboardingItemViewModel> in
                return self.onboardingPageItemViewModel(data: data)
            }.share()
                
        onboardingPageItemViewModel.debug()
            .bind(onNext: { _ in
                cntPage.accept(cntPage.value + 1)
            }).disposed(by: disposeBag)
        
        let appendFirstPage = onboardingPageItemViewModel.take(1).mapToVoid()
        
        let isLastPage = input.currentPageIndex
            .asObservable()
            .flatMapLatest { index -> Observable<Bool> in
                Log.debug(cntPage.value, index)
                if cntPage.value - 1 == index {
                    return Observable.just(true)
                }
                return Observable.just(false)
            }
        
        let goToLogin = Observable.of(input.btnLoginTapped, input.btnStartTapped).merge()
            .map { _ -> LoginViewModel in
                let viewModel = LoginViewModel(withService: self.provider)
                return viewModel
            }
                
        return Output(setPageItemViewModel: onboardingPageItemViewModel.asDriverOnErrorJustComplete(),
                      appendFirstPage: appendFirstPage.asDriverOnErrorJustComplete(),
                      isLastPage: isLastPage.asDriverOnErrorJustComplete(),
                      goToLogin: goToLogin.asDriverOnErrorJustComplete(),
                      goToNextPage: input.btnNextTapped,
                      goToMain: input.btnStartTapped)
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
            let viewModel = OnboardingItemViewModel(withService: self.provider, data: data)
            observer.onNext(viewModel)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
