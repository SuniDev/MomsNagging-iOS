//
//  OnboardingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardingViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    // MARK: - init
    init(withService provider: AppServices) {
        super.init(provider: provider)
    }

    // MARK: - Input
    struct Input {
    }
    
    // MARK: - Output
    struct Output {
        
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        return Output()
    }
    
}

extension OnboardingViewModel {
    
    func onboardingPageViewModel() -> OnboardingPageViewModel {
        let viewModel = OnboardingPageViewModel(withService: provider)
        return viewModel
    }
}
