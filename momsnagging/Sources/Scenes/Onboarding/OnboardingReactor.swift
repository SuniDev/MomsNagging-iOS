//
//  OnboardingReactor.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import Foundation

import RxFlow
import RxCocoa
import ReactorKit

final class OnboardingReactor: Reactor {
    
    // MARK: Events
    enum Action {
    }
    
    enum Mutation {
        case setError(String)
    }
    
    struct State {
        var step: Step?
        var error: String = ""
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
        default: return .empty()
        }
    }
}

// MARK: Reduce
extension OnboardingReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setError(let error):
            newState.error = error
            return newState
        }
    }
}

// MARK: Method
extension OnboardingReactor {
    
}
