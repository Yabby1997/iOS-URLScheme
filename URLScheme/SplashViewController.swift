//
//  SplashViewController.swift
//  URLScheme
//
//  Created by USER on 2022/07/14.
//

import Combine
import UIKit

class SplashViewController: UIViewController {

    private let viewModel: SplashViewModel

    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}

class SplashViewModel {
    var splashDidEndSignalPublisher: AnyPublisher<Void, Never> { splashDidEndSignal.eraseToAnyPublisher() }
    private var splashDidEndSignal = PassthroughSubject<Void, Never>()

    init() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.splashDidEndSignal.send(())
        }
    }
}
