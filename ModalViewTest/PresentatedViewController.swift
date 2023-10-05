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
        
        self.navigationController?.isNavigationBarHidden = false
        
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
        
        for i in 0...10 {
            let view = UIView()
            view.backgroundColor = .blue
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: 100).isActive = true
            if i == 10 {
                view.backgroundColor = .red
            }else if i == 0 {
                view.backgroundColor = .yellow
            }
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
        view.alwaysBounceVertical = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var scView: UIScrollView? {
        get {
          return scrollView
        }
        set {
        }
    }
    
    @objc func dismissSelf() {
        print(self.transitioningDelegate)
        dismiss(animated: true, completion: nil)
    }    
}
