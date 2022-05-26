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
    
    private let data: Observable<Onboarding>
    private let numberOfPages = BehaviorRelay<Int>(value: 5)
    
    // MARK: - init
    init(withService provider: AppServices, data: Onboarding) {
        self.data = Observable.just(data)
        super.init(provider: provider)
    }
    
    // MARK: - Input
    struct Input {
        let btnLoginTapped: Driver<Void>
        let btnNextTapped: Driver<Void>
        let btnStartTapped: Driver<Void>
    }
    
    // MARK: - Output
    struct Output {
        let setTile: Driver<String>
        let setEmoji: Driver<UIImage>
        let setImage: Driver<UIImage>
        let setPageControl: Driver<Int>
        let isLastPage: Driver<Bool>
        let goToLogin: Driver<LoginViewModel>
        let goToNextPage: Driver<Int>
        let goToMain: Driver<Void>
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
        
        let isLastPage = data
            .map { data -> Bool in
                if data.getCurrentPage() == self.numberOfPages.value - 1 {
                    return false
                }
                return true
            }
        
        let currentPage = data.map { data -> Int in
            return data.getCurrentPage()
        }
        
        let goToNextPage = input.btnNextTapped
            .asObservable()
            .flatMapLatest { currentPage }
        
        let goToLogin = Observable.of(input.btnLoginTapped, input.btnStartTapped).merge()
            .map { _ -> LoginViewModel in
                let viewModel = LoginViewModel(withService: self.provider)
                return viewModel
            }
        
        return Output(setTile: currentTitle.asDriverOnErrorJustComplete(),
                      setEmoji: currentEmoji.asDriverOnErrorJustComplete(),
                      setImage: currentImage.asDriverOnErrorJustComplete(),
                      setPageControl: setPageControl.asDriverOnErrorJustComplete(),
                      isLastPage: isLastPage.asDriverOnErrorJustComplete(),
                      goToLogin: goToLogin.asDriverOnErrorJustComplete() ,
                      goToNextPage: goToNextPage.asDriverOnErrorJustComplete(),
                      goToMain: input.btnStartTapped
        )
    }
}
