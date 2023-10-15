//
//  ViewController.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import UIKit

class ViewController: UIViewController {

    var modaltransitionDelegate = BottomSheetTransitionDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Main View Controller"

        let presentButton = UIButton(type: .system)
        presentButton.setTitle("Present Modal", for: .normal)
        presentButton.addTarget(self, action: #selector(presentModal), for: .touchUpInside)
        presentButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(presentButton)

        NSLayoutConstraint.activate([
            presentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            presentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func presentModal() {
        let presentedVC = PresentedViewController(isHeightInteractive: true, modalTransitionDelegate: BottomSheetTransitionDelegate())
        presentedVC.view.backgroundColor = .white
//        let navc = ModalNavigationController(rootViewController: presentedVC)
        let navc = UINavigationController(rootViewController: presentedVC)
        navc.modalPresentationStyle = .custom
        navc.transitioningDelegate = presentedVC.modalTransitionDelegate
        present(navc, animated: true)
    }
}
