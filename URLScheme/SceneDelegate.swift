//
//  SceneDelegate.swift
//  URLScheme
//
//  Created by USER on 2022/06/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var sceneCoordinator: SceneCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let tabBarController = UITabBarController()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        sceneCoordinator = SceneCoordinator(rootViewController: tabBarController)
        sceneCoordinator?.start()

        if let urlContext = connectionOptions.urlContexts.first {
            print(urlContext.url)
            sceneCoordinator?.presentThird()
        } else {
            sceneCoordinator?.presentFirst()
        }
    }

    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        if let urlContext = URLContexts.first {
            print(urlContext.url)
            sceneCoordinator?.presentSecond()
        }
    }
}
