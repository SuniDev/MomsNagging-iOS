//
//  AppStep.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import Foundation

import RxFlow

enum AppStep: Step {
    // Global
    case appStore
    case showPopup(
        type: BasePopupView.PopupType,
        title: String,
        message: String,
        cancelTitle: String?,
        doneTitle: String?,
        cancelHandler: (() -> Void)?,
        doneHandler: (() -> Void)?
    )
    case hidePopup
    
    // Intro
    case introIsRequired
    
    // Onboarding
    case onboardingIsRequired
    case onboardingIsCompleted
    
    // Login
    case loginIsRequired
    case loginIsCompleted
    
    // Main
    case mainTabBarIsRequired
    
    // Home
    case homeIsRequired
    
    // Setting
    case settingIsRequired
}
