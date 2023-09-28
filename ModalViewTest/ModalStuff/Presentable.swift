//
//  Presentable.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

class ModalPresentationDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    
    // custom presentation controller
    // dismissal interactively, meaning that dismissing when swiped down
    // custom animator
        
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        ModalTransitionAnimator(configuration: .init(style: .dismissal, direction: .bottom, transitionDuration: 0.05, hasHapticFeedback: true))
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        ModalTransitionAnimator(configuration: .init(style: .presentation, direction: .bottom, transitionDuration: 0.05, hasHapticFeedback: true))
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {

        PresentationController(presentedViewController: presented, presenting: presenting, configuration: .init(direction: .bottom, sizeMode: .short))
    }
}
