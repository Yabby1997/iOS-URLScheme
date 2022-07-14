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

    var rootNavigationViewController: UINavigationController? { rootViewController as? UINavigationController }
    var rootTabBarController: UITabBarController? { rootViewController as? UITabBarController }

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
        parent?.children.removeAll { $0 == self }
    }
}

extension AnyCoordinator: Hashable {
    static func == (lhs: AnyCoordinator, rhs: AnyCoordinator) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

class SceneCoordinator: AnyCoordinator {
    override func start() {
        super.start()

        let navigationController = UINavigationController()
        let firstCoordinator = FirstCoordinator(rootViewController: navigationController)
        firstCoordinator.parent = self
        firstCoordinator.start()
        firstCoordinator.presentSplashViewController()

        let navigationController2 = UINavigationController()
        let firstCoordinator2 = FirstCoordinator(rootViewController: navigationController2)
        firstCoordinator2.parent = self
        firstCoordinator2.start()
        firstCoordinator2.presentInitialViewController()

        let temp3 = UIViewController()

        rootTabBarController?.viewControllers = [navigationController, navigationController2, temp3]
    }

    func presentFirst() {
        rootTabBarController?.selectedIndex = 0
    }

    func presentSecond() {
        rootTabBarController?.selectedIndex = 1
    }

    func presentThird() {
        rootTabBarController?.selectedIndex = 2
    }
}

class FirstCoordinator: AnyCoordinator {
    func presentSplashViewController() {
        let splashViewModel = SplashViewModel()
        splashViewModel.splashDidEndSignalPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.presentInitialViewController()
            }
            .store(in: &cancellables)

        let splashViewController = SplashViewController(viewModel: splashViewModel)
        rootNavigationViewController?.pushViewController(splashViewController, animated: true)
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
        rootNavigationViewController?.viewControllers = [initialViewController]
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
        rootNavigationViewController?.pushViewController(secondViewController, animated: true)
    }
}
