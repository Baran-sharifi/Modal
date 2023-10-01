//
//  Delegate.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

class ModalPresentationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    
     var presentationController: PresentationController
    
     var dismissalAnimator: ModalTransitionAnimator
    
    var presentationAnimator: ModalTransitionAnimator
    
        
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        dismissalAnimator
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        presentationAnimator
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

       presentationController
    }
    
    init(presentationController: PresentationController, dismissalAnimator: ModalTransitionAnimator, presentationAnimator: ModalTransitionAnimator) {
        self.presentationController = presentationController
        self.dismissalAnimator = dismissalAnimator
        self.presentationAnimator = presentationAnimator
    }
}
