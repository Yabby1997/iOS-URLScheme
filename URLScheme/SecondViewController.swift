//
//  SecondViewController.swift
//  URLScheme
//
//  Created by USER on 2022/07/14.
//

import Combine
import UIKit

import SnapKit

class SecondViewController: UIViewController {

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("EXIT", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    init(viewModel: SecondViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let viewModel: SecondViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .red

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc private func didTapButton(_ sender: UIButton) {
        viewModel.exitButtonDidTap()
    }
}

class SecondViewModel {
    var exitSignalPublisher: AnyPublisher<Void, Never> { exitSignal.eraseToAnyPublisher() }
    private var exitSignal = PassthroughSubject<Void, Never>()

    func exitButtonDidTap() {
        exitSignal.send(())
    }
}
