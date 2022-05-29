//
//  SceneDelegate.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import UIKit

import GoogleSignIn
import RxKakaoSDKAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    /// Service
    static let authService = AuthService()
    static let diaryService = DiaryService()
    
    static var appService = {
        return AppServices(authService: SceneDelegate.authService,
                           diaryService: SceneDelegate.diaryService)
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        let navigator = Navigator.default
        
        let viewModel = IntroViewModel(withService: SceneDelegate.appService)
        navigator.show(seque: .intro(viewModel: viewModel), sender: nil, transition: .root)
//        let viewModel = MainContainerViewModel()
//        navigator.show(seque: .mainContainer(viewModel: viewModel), sender: nil, transition: .root)
//        let viewModel = ContactUsViewModel()
//        navigator.show(seque: .contactUs(viewModel: viewModel), sender: nil, transition: .root)
        
        window?.windowScene = windowScene
        window?.rootViewController = navigator.root
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
}
