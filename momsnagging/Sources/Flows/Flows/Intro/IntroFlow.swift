//
//  IntroFlow.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import Foundation

import RxFlow

final class IntroFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
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
        case .introIsRequired:
            return coordinateToIntro()
        default:
            return .none
        }
    }
    
    private func coordinateToIntro() -> FlowContributors {
        let reactor = IntroReactor(provider: provider)
        let viewController = IntroViewController(with: reactor)
        
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewController))
    }
}
