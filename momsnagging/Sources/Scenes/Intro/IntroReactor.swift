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

final class IntroReactor: Reactor {
    
    // MARK: Events
    enum Action {
        case willAppearIntro
        case tappedForceUpdate
        case tappedLaterUpdate
    }
    
    enum Mutation {
        case setStep(AppStep)
        case setAppUpdateStatus(AppUpdateStatus)
        case setError(String)
    }
    
    struct State {
        var step: Step?
        var updateStatus: AppUpdateStatus = .none
        var shouldShowForceUpdatePopup: Bool = false
        var shouldShowSelectUpdatePopup: Bool = false
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
extension IntroReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .willAppearIntro:
            return provider.appUpdateService.fetchAppUpdateStatus()
                .map { Mutation.setAppUpdateStatus($0) }
                .catch { _ in
                    return Observable.just(Mutation.setAppUpdateStatus(.error))
                }
        case .tappedForceUpdate:
            return Observable.just(Mutation.setStep(.moveAppStore))
        case .tappedLaterUpdate:
            return Observable.just(Mutation.setStep(AppStep.introIsComplete))
        default: return .empty()
        }
    }
}

// MARK: Reduce
extension IntroReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setStep(let step):
            newState.step = step
        case .setAppUpdateStatus(let status):
            newState.updateStatus = status
            switch status {
            case .forceUpdate:
                newState.shouldShowForceUpdatePopup = true
                newState.shouldShowSelectUpdatePopup = false
            case .selectUpdate:
                newState.shouldShowForceUpdatePopup = false
                newState.shouldShowSelectUpdatePopup = true
            case .latestVersion, .none:
                newState.shouldShowForceUpdatePopup = false
                newState.shouldShowSelectUpdatePopup = false
                newState.step = AppStep.introIsComplete
            case .error:
                newState.error = "Error - Fetch Update"
                newState.step = AppStep.introIsComplete
            }
        case .setError(let error):
            newState.error = error
        }

        return newState
    }
}

// MARK: Method
private extension IntroReactor {
    
}
