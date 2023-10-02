//
//  PresentatedViewController.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/1/23.
//

import Foundation
import UIKit

class PresentedViewController: PresentableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        view.alpha = 0.7
        title = "Presented View Controller"
                
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
        ])
        
        for _ in 0...11 {
            let view = UIView()
            view.backgroundColor = .blue
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
            view.widthAnchor.constraint(equalToConstant: 300).isActive = true
            view.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
    }
         
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .white
        view.spacing = 2
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    public lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    
    @objc func dismissSelf() {
        print(self.transitioningDelegate)
        dismiss(animated: true, completion: nil)
    }    
}
