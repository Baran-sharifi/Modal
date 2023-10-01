//
//  ViewController.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import UIKit

class ViewController: UIViewController {

    
    
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
        let presentedVC = PresentedViewController(isHeightInteractive: true)
        presentedVC.transitioningDelegate = ModalPresentationDelegate.init(presentationController: PresentationController(presentedViewController: presentedVC, presenting: self, configuration: <#T##PresentationConfiguration#>), dismissalAnimator: ModalTransitionAnimator, presentationAnimator: <#T##ModalTransitionAnimator#>)
        present(presentedVC, animated: true, completion: nil)
    }
}