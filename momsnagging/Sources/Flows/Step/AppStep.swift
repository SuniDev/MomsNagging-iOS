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
        type: AppPopup.PopupType,
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
    case introIsCompleted
    
    // Onboarding
    case onboardingIsRequired
    case onboardingIsCompleted
    
    // Nickname Setting
    case nicknameSettingIsRequired
    case nicknameSettingIsCompleted
    
    // Main
    case mainTabBarIsRequired
    
    // Home
    case homeIsRequired
    
    // Setting
    case settingIsRequired
}
