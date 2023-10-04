//
//  NavigationControlle.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/4/23.
//

import UIKit
import Foundation

class ModalNavigationController: UINavigationController {

    var currentPresentableViewController: UIViewController
    
    var modalTransitionDelegate: UIViewControllerTransitioningDelegate? {
        if let pvc = currentPresentableViewController as? PresentableViewController {
            return pvc.modalTransitionDelegate
        } else {
            return BottomSheetTransititionDelegate()
        }
    }
    
    override init(rootViewController: UIViewController) {
        self.currentPresentableViewController = rootViewController
        
        super.init(rootViewController: rootViewController)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = modalTransitionDelegate
        self.navigationBar.isUserInteractionEnabled = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func navBarTapped() {
        
    }
}

// so navigationController gets present and
