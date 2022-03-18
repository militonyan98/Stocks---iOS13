//
//  SceneDelegate.swift
//  Stocks
//
//  Created by Hermine M on 02/03/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    /// Main app window
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let vc = WatchListViewController()
        let navVC = UINavigationController(rootViewController: vc)
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        
        self.window = window
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

