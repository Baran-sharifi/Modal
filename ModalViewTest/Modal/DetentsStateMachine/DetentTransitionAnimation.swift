//
//  DetentTransitionAnimation.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation
import UIKit

class DetentAnimationTransition: StateMachineAnimatorDelegate {
    
    var animationCompleted: Bool = true
    
    var presentationController: PresentationController
    
    func animateTransitionToSize(_ size: PresentationDetent) {
        
        presentationController.configuration.sizeMode = size
        
        UIView.animate(withDuration: 0.45, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            var newSize: CGSize
            
            guard let self = self else { return }
            newSize = presentationController.presentedViewSize(basedOn: size)
            presentationController.presentedView?.frame = presentationController.presentedViewFrame(basedOn: presentationController.configuration.direction, size: newSize)
            presentationController.presentedView?.layoutIfNeeded()
        }, completion: { finished in
            self.animationCompleted = finished
        })
    }
    
    init(presentationController: PresentationController) {
        self.presentationController = presentationController
    }
}
