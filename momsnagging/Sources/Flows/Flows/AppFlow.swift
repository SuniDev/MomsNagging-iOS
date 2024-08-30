//
//  AppFlow.swift
//  momsnagging
//
//  Created by suni on 8/31/24.
//

import Foundation

import RxFlow
import RxCocoa
import RxSwift

struct AppStepper: Stepper {
    let steps: PublishRelay<Step> = .init()
    private let provider: ServiceProviderType
    private let disposeBag: DisposeBag = .init()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    var initialStep: Step {
        return AppStep.intro
    }
    
    func readyToEmitSteps() {
        //        provider.loginService.didLoginObservable
        //            .map { $0 ? SampleStep.loginIsCompleted : SampleStep.loginIsRequired }
        //            .bind(to: steps)
        //            .disposed(by: disposeBag)
    }
}

// Flow는 AnyObject를 준수하므로 class로 선언해주어야 한다.
final class AppFlow: Flow {
    var root: Presentable {
        return self.rootWindow
    }
    
    private let rootWindow: UIWindow
    private let provider: ServiceProviderType
    
    init(
        with window: UIWindow,
        and services: ServiceProviderType
    ) {
        self.rootWindow = window
        self.provider = services
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return FlowContributors.none }
        
        switch step {
        case .intro:
            return navigationToIntroScreen()
        default:
            return .none
        }
    }
    
    private func navigationToIntroScreen() -> FlowContributors {
        let flow = IntroFlow(with: provider)
        
        Flows.use(flow, when: .created) { [unowned self] root in
            self.rootWindow.rootViewController = root
        }
        
        let nextStep = OneStepper(withSingleStep: AppStep.intro)
        
        return .one(flowContributor: .contribute(withNextPresentable: flow,
                                                 withNextStepper: nextStep))
    }
}
