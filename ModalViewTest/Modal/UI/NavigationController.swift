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
        if let presentedVC = currentPresentableViewController as? PresentableViewController {
            return presentedVC.modalTransitionDelegate
        } else {
            return BottomSheetTransitionDelegate()
        }
    }
    
    override init(rootViewController: UIViewController) {
        self.currentPresentableViewController = rootViewController
        
        super.init(rootViewController: rootViewController)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = modalTransitionDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
