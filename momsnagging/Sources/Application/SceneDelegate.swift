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
    private let flow: FlowCoordinator = .init()
    private let disposeBag: DisposeBag = .init()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        coordinatorLogStart()
        
        // App Initialize
        
        coordinateToAppFlow(with: windowScene)
    }
    
    private func coordinateToAppFlow(with windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        let provider: ServiceProviderType = ServiceProvider()
        let appFlow = AppFlow(with: window, and: provider)
        let appStepper = AppStepper(provider: provider)
        
        flow.coordinate(flow: appFlow, with: appStepper)
        
        window.makeKeyAndVisible()
    }
    
    private func coordinatorLogStart() {
        flow.rx.willNavigate
            .subscribe(onNext: { flow, step in
                let currentFlow = "\(flow)".split(separator: ".").last ?? "no flow"
                Log.info("➡️ will navigate to flow = \(currentFlow) and step = \(step)")
            })
            .disposed(by: disposeBag)
        
        // didNavigate
    }
}
