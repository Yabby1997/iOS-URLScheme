//
//  AnyCoordinator.swift
//  URLScheme
//
//  Created by USER on 2022/07/14.
//

import Combine
import UIKit

class AnyCoordinator {
    var children: [AnyCoordinator] = []
    weak var parent: AnyCoordinator?
    let rootViewController: UIViewController

    var navigationController: UINavigationController? { rootViewController as? UINavigationController }
    var tabController: UITabBarController? { rootViewController as? UITabBarController }

    var cancellables: Set<AnyCancellable> = []

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    /// Start and present
    func start() {
        parent?.children.append(self)
    }

    /// Dismiss and stop
    func stop() {
        parent?.children.removeAll { $0 === self }
    }
}

class SceneCoordinator: AnyCoordinator {
    override func start() {
        super.start()

        let appearance: UITabBarAppearance = {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .systemBackground
            return appearance
        }()
        tabController?.tabBar.standardAppearance = appearance
        tabController?.tabBar.scrollEdgeAppearance = appearance

        let navigationController = UINavigationController()
        navigationController.tabBarItem = .init(
            title: "First",
            image: UIImage(systemName: "heart"),
            selectedImage:  UIImage(systemName: "heart.fill")
        )
        let firstCoordinator = FirstCoordinator(rootViewController: navigationController)
        firstCoordinator.parent = self
        firstCoordinator.start()
        firstCoordinator.presentSplashViewController()

        let navigationController2 = UINavigationController()
        navigationController2.tabBarItem = .init(
            title: "Second",
            image: UIImage(systemName: "heart"),
            selectedImage:  UIImage(systemName: "heart.fill")
        )
        let firstCoordinator2 = FirstCoordinator(rootViewController: navigationController2)
        firstCoordinator2.parent = self
        firstCoordinator2.start()
        firstCoordinator2.presentInitialViewController()

        let temp3 = UIViewController()
        temp3.tabBarItem = .init(
            title: "Third",
            image: UIImage(systemName: "heart"),
            selectedImage:  UIImage(systemName: "heart.fill")
        )
        temp3.view.backgroundColor = .magenta

        tabController?.viewControllers = [navigationController, navigationController2, temp3]
    }

    func presentFirst() {
        tabController?.selectedIndex = 0
    }

    func presentSecond() {
        tabController?.selectedIndex = 1
    }

    func presentThird() {
        tabController?.selectedIndex = 2
    }
}

class FirstCoordinator: AnyCoordinator {

    override func start() {
        super.start()

        let appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .systemBackground
            return appearance
        }()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func presentSplashViewController() {
        let splashViewModel = SplashViewModel()
        splashViewModel.splashDidEndSignalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.presentInitialViewController()
            }
            .store(in: &cancellables)

        let splashViewController = SplashViewController(viewModel: splashViewModel)
        navigationController?.pushViewController(splashViewController, animated: true)
    }

    func presentInitialViewController() {
        let initialViewModel = InitialViewModel()
        initialViewModel.pushSignalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.startSecondCoordinator()
            }
            .store(in: &cancellables)

        let initialViewController = InitialViewController(viewModel: initialViewModel)
        navigationController?.viewControllers = [initialViewController]
    }

    private func startSecondCoordinator() {
        let navigationController = UINavigationController()
        let secondCoordinator = SecondCoordinator(rootViewController: navigationController)
        secondCoordinator.parent = self
        secondCoordinator.start()
        secondCoordinator.presentSecondViewController()
        navigationController.modalPresentationStyle = .fullScreen
        rootViewController.present(navigationController, animated: true)
    }
}

class SecondCoordinator: AnyCoordinator {

    override func start() {
        super.start()

        let appearance: UINavigationBarAppearance = {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .systemBackground
            return appearance
        }()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func presentSecondViewController() {
        let secondViewModel = SecondViewModel()
        secondViewModel.exitSignalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rootViewController.dismiss(animated: true)
                self?.stop()
            }
            .store(in: &cancellables)

        let secondViewController = SecondViewController(viewModel: secondViewModel)
        navigationController?.pushViewController(secondViewController, animated: true)
    }
}
