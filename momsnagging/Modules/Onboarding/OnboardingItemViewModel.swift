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
    }
    
    // MARK: - Output
    struct Output {
        let setEmoji: Driver<UIImage>
        let setTile: Driver<String>
        let setDescription: Driver<String>
        let setImage: Driver<UIImage>
        let setBubble: Driver<UIImage>
        let setPageControl: Driver<(Int, Int)>
        let isLastPage: Driver<Bool>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
        
        let setEmoji = data.map { data -> UIImage in
            return data.getEmoji()
        }
        let setTitle = data.map { data -> String in
            return data.getTitle()
        }
        let setDescription = data.map { data -> String in
            return data.getMessage()
        }
        let setImage = data.map { data -> UIImage in
            return data.getImage()
        }
        let setBubble = data.map { data -> UIImage  in
            return data.getBubbleImage()
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
        
        return Output(setEmoji: setEmoji.asDriverOnErrorJustComplete(),
                      setTile: setTitle.asDriverOnErrorJustComplete(),
                      setDescription: setDescription.asDriverOnErrorJustComplete(),
                      setImage: setImage.asDriverOnErrorJustComplete(),
                      setBubble: setBubble.asDriverOnErrorJustComplete(),
                      setPageControl: setPageControl.asDriverOnErrorJustComplete(),
                      isLastPage: isLastPage.asDriverOnErrorJustComplete()
        )
    }
}
