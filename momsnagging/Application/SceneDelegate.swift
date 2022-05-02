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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        let navigator = Navigator.default
        
//        let viewModel = IntroViewModel()
//        navigator.show(seque: .intro(viewModel: viewModel), sender: nil, transition: .root)
        
        let viewModel = NicknameSettingViewModel(loginInfo: LoginInfo(authToken: nil, authId: nil, email: nil, snsType: nil))
        navigator.show(seque: .nicknameSetting(viewModel: viewModel), sender: nil, transition: .root)
//        let viewModel = IDSettingViewModel(loginInfo: LoginInfo(authToken: nil, authId: nil, email: nil, snsType: nil))
//        navigator.show(seque: .idSetting(viewModel: viewModel), sender: nil, transition: .root)
        
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
