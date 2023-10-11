//
//  Delegate.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

class BottomSheetTransititionDelegate: NSObject, UIViewControllerTransitioningDelegate {
        
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTransitionAnimator(configuration: .init(animationState: .dismissal, direction: .bottom, transitionDuration: 2, hasHapticFeedback: true))
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalTransitionAnimator(configuration: .init(animationState: .presentation, direction: .bottom, transitionDuration: 2, hasHapticFeedback: true))
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController.init(presentedViewController: presented, presenting: presenting, configuration: .init(isInteractiveSizeSupported: true, direction: .bottom, sizeMode: .fullScreen))
    }
}
