//
//  OnboardingReactor.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import Foundation
import UIKit

import RxFlow
import RxCocoa
import ReactorKit

final class OnboardingReactor: Reactor {
    
    // MARK: Events
    enum Action {
        case nextPage
        case previousPage
        case setPage(Int)
    }
    
    enum Mutation {
        case setError(String)
        case setPageIndex(Int)
    }
    
    struct State {
        var step: Step?
        var error: String = ""
        var currentPageIndex: Int = 0
        var onboardings: [Onboarding] = [
            Onboarding(currentPage: 0),
            Onboarding(currentPage: 1),
            Onboarding(currentPage: 2),
            Onboarding(currentPage: 3),
            Onboarding(currentPage: 4)
        ]
    }
    
    // MARK: Properties
    let initialState: State
    let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        initialState = State()
    }
}

// MARK: Mutation
extension OnboardingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nextPage:
            let nextPage = min(currentState.currentPageIndex + 1, currentState.onboardings.count - 1)
            return Observable.just(.setPageIndex(nextPage))

        case .previousPage:
            let previousPage = max(currentState.currentPageIndex - 1, 0)
            return Observable.just(.setPageIndex(previousPage))

        case .setPage(let index):
            return Observable.just(.setPageIndex(index))
            
        default: return .empty()
        }
    }
}

// MARK: Reduce
extension OnboardingReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setPageIndex(let pageIndex):
            newState.currentPageIndex = pageIndex
            
        case .setError(let error):
            newState.error = error
        }
        return newState
    }
}

// MARK: Method
extension OnboardingReactor {
    
}
