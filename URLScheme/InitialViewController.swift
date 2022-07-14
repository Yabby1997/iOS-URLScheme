//
//  InitialViewController.swift
//  URLScheme
//
//  Created by USER on 2022/06/26.
//

import Combine
import UIKit

import SnapKit

class InitialViewController: UIViewController {

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("PUSH", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    init(viewModel: InitialViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let viewModel: InitialViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .yellow

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc private func didTapButton(_ sender: UIButton) {
        viewModel.pushButtonDidTap()
    }
}

class InitialViewModel {
    var pushSignalPublisher: AnyPublisher<Void, Never> { pushSignal.eraseToAnyPublisher() }
    private var pushSignal = PassthroughSubject<Void, Never>()

    func pushButtonDidTap() {
        pushSignal.send(())
    }
}
