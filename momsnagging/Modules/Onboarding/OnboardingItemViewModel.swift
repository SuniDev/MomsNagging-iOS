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
    
    init(data: Onboarding) {
        self.data = Observable.just(data)
    }
    
    // MARK: - Input
    struct Input {
    }
    
    // MARK: - Output
    struct Output {
        let setTile: Driver<String>
        let setDescription: Driver<String>
        let setImage: Driver<UIImage>
        let setBubble: Driver<UIImage>
    }
    
    // MARK: - transform
    func transform(input: Input) -> Output {
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
        
        return Output(setTile: setTitle.asDriverOnErrorJustComplete(),
                      setDescription: setDescription.asDriverOnErrorJustComplete(),
                      setImage: setImage.asDriverOnErrorJustComplete(),
                      setBubble: setBubble.asDriverOnErrorJustComplete())
    }
}
