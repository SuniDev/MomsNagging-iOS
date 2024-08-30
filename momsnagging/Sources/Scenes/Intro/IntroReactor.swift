//
//  IntroReactor.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import Foundation

import RxFlow
import RxCocoa
import ReactorKit

final class IntroReactor: Reactor, Stepper {
    
    // MARK: Stepper
    var steps: PublishRelay<Step> = .init()
    
    // MARK: Events
    enum Action {
        case loginButtonDidTap
    }
    
    enum Mutation {
    }
    
    struct State {
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
extension IntroReactor {
    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .loginButtonDidTap:
//            provider.loginService.setUserLogin()
//            
//            steps.accept(SampleStep.loginIsCompleted)
            return .empty()
//        }
    }
}

// MARK: Reduce
extension IntroReactor {
    func reduce(state: State, mutation: Mutation) -> State {
//        var newState = state
//
//        switch mutation {
//        }
//
//        return newState
    }
}

// MARK: Method
private extension IntroReactor {
}
