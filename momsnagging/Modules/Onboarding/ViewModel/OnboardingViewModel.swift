//
//  OnboardingViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/03/28.
//

import Foundation
import RxSwift
import RxCocoa

class OnboardingViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    override init() {
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
        let viewModel = OnboardingPageViewModel()
        return viewModel
    }
}
