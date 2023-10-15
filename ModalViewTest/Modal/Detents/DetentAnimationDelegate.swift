//
//  DetentTransitionAnimation.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation
import UIKit

protocol StateMachineAnimatorDelegate: AnyObject {
    
    var animationCompleted: Bool { get set }
    
    func animateTransitionToSize(_ size: PresentationDetent)
    func animateInteractiveHeight(_ height: CGFloat)
}

class DetentAnimationDelegate: StateMachineAnimatorDelegate {
    
    var animationCompleted: Bool = true
    
    var presentationController: PresentationController
    
    init(presentationController: PresentationController) {
        self.presentationController = presentationController
    }
    
    func animateTransitionToSize(_ size: PresentationDetent) {
        
        presentationController.configuration.sizeMode = size
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            
            guard let self = self else { return }
            let newSize = presentationController.presentedViewSize(basedOn: size)
            presentationController.presentedView?.frame = presentationController.presentedViewFrame(basedOn: presentationController.configuration.direction, size: newSize)
            presentationController.presentedView?.layoutIfNeeded()
        }, completion: { finished in
            self.animationCompleted = finished
        })
    }
    
    func animateInteractiveHeight(_ height: CGFloat) {
        
        let newSize = CGSize.init(width: presentationController.containerView?.bounds.width ?? 300, height: (presentationController.presentedView?.frame.height)! + height)
        UIView.animate(withDuration: 0.2, delay: 0, animations: { [weak self] in
            
            guard let self = self else { return }
            presentationController.presentedView?.frame = presentationController.presentedViewFrame(basedOn: presentationController.configuration.direction, size: newSize)
            presentationController.presentedView?.layoutIfNeeded()
        }, completion: { finished in
            self.animationCompleted = finished
        })
    }
}
