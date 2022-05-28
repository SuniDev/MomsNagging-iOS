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
    let authService = AuthService()
    let diaryService = DiaryService()
    lazy var appService = {
        return AppServices(authService: self.authService,
                           diaryService: self.diaryService)
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        let navigator = Navigator.default
        
//        let viewModel = IntroViewModel(withService: appService)
//        navigator.show(seque: .intro(viewModel: viewModel), sender: nil, transition: .root)
//        let viewModel = MainContainerViewModel()
//        navigator.show(seque: .mainContainer(viewModel: viewModel), sender: nil, transition: .root)
//        let viewModel = DeleteAccountViewModel()
//        navigator.show(seque: .deleteAccount(viewModel: viewModel), sender: nil, transition: .root)
        
        CommonUser.authorization = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJwcm92aWRlciI6Iktha2FvIiwiaWQiOiJsZWVqYXNpayIsImVtYWlsIjoiamFzaWtAdGVzdC5jb20iLCJzdWIiOiI4IiwiaWF0IjoxNjUzNjUzMDI2fQ.R8LnhFaBV2bxlS5tciKYrsCmsX_pOoBnNuUQIOPh9RDLdTfIKzsqz90shQsqj64918fTqQN7j0WpFy1vKB3KVg"
        let viewModel = DiaryViewModel(withService: appService)
        navigator.show(seque: .diary(viewModel: viewModel), sender: nil, transition: .root)
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
