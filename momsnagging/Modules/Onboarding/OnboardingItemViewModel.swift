//
//  OnboardingPageViewModel.swift
//  momsnagging
//
//  Created by suni on 2022/04/23.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingItemViewModel: BaseViewModel, ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private let data: Observable<Onboarding>
    private let numberOfPages = BehaviorRelay<Int>(value: 5)
    
    init(data: Onboarding) {
        self.data = Observable.just(data)
    }
    
    // MARK: - Input
    struct Input {
        let btnLoginTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let setTile: Driver<String>
        let setEmoji: Driver<UIImage>
        let setImage: Driver<UIImage>
        let setPageControl: Driver<(Int, Int)>
        let isLastPage: Driver<Bool>
        let btnLoginTapped: Driver<Void>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        let setTitle = data.map { data -> String in
            return data.getTitle()
        }
        
        let setEmoji = data.map { data -> UIImage in
            return data.getEmoji()
        }
        
        let setImage = data.map { data -> UIImage in
            return data.getImage()
        }
                
        let setPageControl = Observable.zip(self.numberOfPages, data.map { data -> Int in
            return data.getCurrentPage()
        })
        
        let isLastPage = data
            .map { data -> Bool in
                if data.getCurrentPage() == self.numberOfPages.value - 1 {
                    return false
                }
                return true
            }
    
        return Output(setTile: setTitle.asDriverOnErrorJustComplete(),
                      setEmoji: setEmoji.asDriverOnErrorJustComplete(),
                      setImage: setImage.asDriverOnErrorJustComplete(),
                      setPageControl: setPageControl.asDriverOnErrorJustComplete(),
                      isLastPage: isLastPage.asDriverOnErrorJustComplete(),
                      btnLoginTapped: input.btnLoginTapped
        )
    }
}
