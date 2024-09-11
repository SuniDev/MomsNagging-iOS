//
//  AppStep.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import Foundation

import RxFlow

enum AppStep: Step {
    case introIsRequired
    case introIsComplete
    case moveToAppStore
}
