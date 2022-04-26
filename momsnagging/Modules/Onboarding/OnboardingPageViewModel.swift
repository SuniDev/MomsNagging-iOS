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
        
    }
    
    // MARK: - Output
    struct Output {
        let setPage: Driver<OnboardingItemViewController>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        let getDatas = self.getOnboardDatas()
                
        let getPages = getDatas
            .flatMapLatest { data -> Observable<OnboardingItemViewController> in
                return self.getPageVC(data: data)
            }.asDriverOnErrorJustComplete()
        
        return Output(setPage: getPages)
    }
}

extension OnboardingPageViewModel {
    
        // TODO: 온보딩 이미지 초기화
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
    
    func getPageVC(data: Onboarding) -> Observable<OnboardingItemViewController> {
        return Observable<OnboardingItemViewController>.create { observer -> Disposable in
            let vc = OnboardingItemViewController(viewModel: OnboardingItemViewModel(data: data))
            observer.onNext(vc)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
