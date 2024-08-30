//
//  SceneDelegate.swift
//  momsnagging
//
//  Created by 전창평 on 2022/03/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        
        window?.windowScene = windowScene
//        window?.rootViewController = navigator.root
        window?.makeKeyAndVisible()
    }
}
