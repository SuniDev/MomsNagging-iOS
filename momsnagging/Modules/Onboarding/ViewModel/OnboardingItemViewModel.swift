//
//  OnboardingPageViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingItemViewModel: ViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let data: BehaviorRelay<Onboarding>
    private let numberOfPages = BehaviorRelay<Int>(value: 5)
    
    // MARK: - init
    init(withService provider: AppServices, data: Onboarding) {
        self.data = BehaviorRelay<Onboarding>(value: data)
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
    }
    
    // MARK: - Output
    struct Output {
        let setImage: Driver<UIImage>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
                
        let currentImage = data.map { data -> UIImage in
            return data.getImage()
        }
        
        return Output(setImage: currentImage.asDriverOnErrorJustComplete())
    }
}
