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
        case let .showPopup(type, title, message, cancelTitle, doneTitle, cancelHandler, doneHandler):
            return showPopup(type: type, title: title, message: message, cancelTitle: cancelTitle, doneTitle: doneTitle, cancelHandler: cancelHandler, doneHandler: doneHandler)
        case .hidePopup:
            return hidePopup()
        case .introIsRequired:
            return coordinateToIntro()
        case .onboardingIsRequired:
            return .end(forwardToParentFlowWithStep: AppStep.onboardingIsRequired)
        case .homeIsRequired:
            return .end(forwardToParentFlowWithStep: AppStep.homeIsRequired)
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
    
    private func showPopup(
        type: BasePopupView.PopupType,
        title: String = "",
        message: String = "",
        cancelTitle: String? = nil,
        doneTitle: String? = nil,
        cancelHandler: (() -> Void)? = nil,
        doneHandler: (() -> Void)? = nil
    ) -> FlowContributors {
        let popup = BasePopupView()
        popup.setUI(
            popupType: type,
            title: title,
            message: message,
            cancelTitle: cancelTitle ?? "취소",
            doneTitle: doneTitle ?? "확인",
            cancelHandler: cancelHandler,
            doneHandler: doneHandler
        )
        
        popup.showAnim(vc: rootViewController, parentAddView: nil, completion: nil)
        return .none
    }
    
    private func hidePopup() -> FlowContributors {
        
        if let popup = rootViewController.children.compactMap({ $0 as? BasePopupView }).first {
            popup.hideAnim()
        }
        
        return .none
    }
}
