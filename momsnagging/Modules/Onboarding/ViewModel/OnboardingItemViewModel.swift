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
        let setTile: Driver<String>
        let setEmoji: Driver<UIImage>
        let setImage: Driver<UIImage>
        let setPageControl: Driver<Int>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        let currentTitle = data.map { data -> String in
            return data.getTitle()
        }
        
        let currentEmoji = data.map { data -> UIImage in
            return data.getEmoji()
        }
        
        let currentImage = data.map { data -> UIImage in
            return data.getImage()
        }
                
        let setPageControl = data.map { data -> Int in
            return data.getCurrentPage()
        }
        
        return Output(setTile: currentTitle.asDriverOnErrorJustComplete(),
                      setEmoji: currentEmoji.asDriverOnErrorJustComplete(),
                      setImage: currentImage.asDriverOnErrorJustComplete(),
                      setPageControl: setPageControl.asDriverOnErrorJustComplete()
        )
    }
}
