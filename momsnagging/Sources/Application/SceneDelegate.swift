//
//  SceneDelegate.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import UIKit

import RxFlow
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let coordinator = FlowCoordinator()
    private let disposeBag: DisposeBag = .init()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // App Initialize
        coordinatorLogStart()
        coordinateToAppFlow(with: windowScene)
    }
    
    private func coordinateToAppFlow(with windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let provider: ServiceProviderType = ServiceProvider()
        let appStepper = AppStepper(provider: provider)
        
        let appFlow = AppFlow(with: window, and: provider)
        coordinator.coordinate(flow: appFlow, with: appStepper)
        
        window.makeKeyAndVisible()
    }
    
    private func coordinatorLogStart() {
        coordinator.rx.willNavigate
            .subscribe(onNext: { flow, step in
                let currentFlow = "\(flow)".split(separator: ".").last ?? "no flow"
                Log.info("\n➡️ will navigate to flow = \(currentFlow) and step = \(step)")
            })
            .disposed(by: disposeBag)
        
        coordinator.rx.didNavigate.subscribe(onNext: { flow, step in
            Log.info("\n➡️ did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)
    }
}
