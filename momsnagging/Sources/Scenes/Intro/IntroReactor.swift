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
        case laterUpdateButtonDidTap
        case updateButtonDidTap
    }
    
    enum Mutation {
        case showForceUpdatePopup
        case showSelectUpdatePopup
        case moveToAppStore
        case moveToOnboarding
        case setError(String)
        case todo
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
extension IntroReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .willAppearIntro:
            return provider.appUpdateService.fetchAppUpdateStatus()
                .flatMap { status -> Observable<Mutation> in
                    switch status {
                    case .forceUpdate:
                        return .just(Mutation.showForceUpdatePopup)
                    case .selectUpdate:
                        return .just(Mutation.showSelectUpdatePopup)
                    case .latestVersion, .none:
                        return .just(Mutation.todo)
                    case .error:
                        return .just(Mutation.setError("Error - Fetch Update"))
                    }
                }
                .catch { _ in
                    return .just(Mutation.setError("Error - Fetch Update"))
                }
        case .updateButtonDidTap:
            return .just(Mutation.moveToAppStore)
        case .laterUpdateButtonDidTap:
            return provider.userDefaultsService.value(forKey: .isCompleteOnboard)
                .asObservable()
                .flatMap { [weak self] isCompleteOnboard -> Observable<Mutation> in
                    guard let self else { return .empty() }
                    
                    if let isCompleteOnboard, isCompleteOnboard {
                        // 앱 재실행
                        // TODO: - Home 이동 추가
                        return .just(.moveToOnboarding)
                    } else {
                        // 앱 첫 실행
                        return Observable.just(.moveToOnboarding)
                    }
                }
        default: return .empty()
        }
    }
}

// MARK: Reduce
extension IntroReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setError(let error):
            newState.error = error
        case .showForceUpdatePopup:
            newState.step = AppStep.showPopup(
                type: .forceUpdate,
                title: L10n.updateTitle,
                message: L10n.updateMessage,
                cancelTitle: nil,
                doneTitle: L10n.updateDone,
                cancelHandler: nil,
                doneHandler: {
                    self.action.onNext(.updateButtonDidTap)
                })
        case .showSelectUpdatePopup:
            newState.step = AppStep.showPopup(
                type: .selectUpdate,
                title: L10n.updateTitle,
                message: L10n.updateMessage,
                cancelTitle: L10n.updateCancel,
                doneTitle: L10n.updateDone,
                cancelHandler: {
                    self.action.onNext(.laterUpdateButtonDidTap)
                },
                doneHandler: {
                    self.action.onNext(.updateButtonDidTap)
                })
        case .moveToAppStore:
            newState.step = AppStep.appStore
        case .todo:
            // TODO: -
            break
        case .moveToOnboarding:
            newState.step = AppStep.onboardingIsRequired
        }

        return newState
    }
}

// MARK: Method
private extension IntroReactor {
    
}
