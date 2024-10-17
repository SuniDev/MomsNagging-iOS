//
//  OnboardingFlow.swift
//  momsnagging
//
//  Created by suni on 9/12/24.
//

import Foundation

import RxFlow

final class OnboardingFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    private let provider: ServiceProviderType
    
    init(with provider: ServiceProviderType) {
        self.provider = provider
    }
    
    deinit {
        Log.info("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return FlowContributors.none }
        
        switch step {
        case .onboardingIsRequired:
            return coordinateToOnboarding()
        case .nicknameSettingIsRequired:
            return coordinateToNicknameSetting()
        default:
            return .none
        }
    }
    
    private func coordinateToOnboarding() -> FlowContributors {
        let reactor = OnboardingReactor(provider: provider)
        let viewController = OnboardingViewController(with: reactor)
        
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
    
    private func coordinateToNicknameSetting() -> FlowContributors {
        let reactor = NicknameSettingReactor(provider: provider)
        let viewController = NicknameSettingViewController(with: reactor)
        
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
}
