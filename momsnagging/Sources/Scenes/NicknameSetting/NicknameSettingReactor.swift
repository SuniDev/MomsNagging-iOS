//
//  NicknameSettingReactor.swift
//  momsnagging
//
//  Created by suni on 9/24/24.
//

import Foundation

import RxFlow
import RxCocoa
import ReactorKit

final class NicknameSettingReactor: Reactor {
    
    // MARK: Events
    enum Action {
        case willAppearNicknameSetting
    }
    
    enum Mutation {
        case moveToHome
        case setError(String)
        case todo
    }

    struct State {
        var step: Step?
        var error: String = ""
        var isEditView: Bool = false
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

// MARK: Reduce

// MARK: Method
