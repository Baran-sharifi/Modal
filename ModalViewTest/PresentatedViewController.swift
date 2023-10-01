//
//  PresentatedViewController.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/1/23.
//

import Foundation
import UIKit

class PresentedViewController: PresentableViewController {
    
    override var preferredContentSize: CGSize {
        get {
            // Set your custom size here
            return CGSize(width: 50, height: 100)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.alpha = 0.7
        title = "Presented View Controller"
        
        let dismissButton = UIButton(type: .system)
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func dismissSelf() {
        print(self.transitioningDelegate)
        dismiss(animated: true, completion: nil)
    }
}

