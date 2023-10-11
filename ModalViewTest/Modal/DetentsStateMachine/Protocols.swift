//
//  Protocols.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation

protocol StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate)
    func routeBasedOn(event: ModalTransitionEvents) -> StateProtocol?
}

protocol StateMachineAnimatorDelegate: AnyObject {
    func animateTransitionToSize(_ size: PresentationDetent)
    func animateInteractiveHeight(_ height: CGFloat)
    var animationCompleted: Bool {get set}
}
