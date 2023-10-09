//
//  States.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation

//MARK: - States ...

struct FullScreenState: StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate) {
        animator.animateTransitionToSize(.fullScreen)
    }
    
    func routeBasedOn(event: EventProtocol) -> StateProtocol? {
        
        guard let event = event as? ModalTransitionEvents else {return self}
        switch event {
        case .navBarPan(translationY: let translation):
            return translation >= 0.001 ? DetentFactory.compactState : nil
        default:
            return nil
        }
    }
}

struct ShortConstantState: StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate) {
        animator.animateTransitionToSize(.short)
    }
    
    func routeBasedOn(event: EventProtocol) -> StateProtocol? {
        
        guard let event = event as? ModalTransitionEvents else {return self}
        switch event {
        case .navBarPan(translationY: let translation):
            return translation <= -0.001 ? DetentFactory.compactState : nil
        case.scrollViewPan(contentOffset: let offset, maxVerticalOffset: let maxOffset):
            return offset >= maxOffset ? DetentFactory.compactState : nil
        }
    }
}

struct CompactState: StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate) {
        animator.animateTransitionToSize(.compact)
    }
    
    func routeBasedOn(event: EventProtocol) -> StateProtocol? {
        
        guard let event = event as? ModalTransitionEvents else {return self}
        switch event {
        case .navBarPan(translationY: let translation):
            return translation <= -0.001 ? DetentFactory.fullScreenState : DetentFactory.shortScreenState
        case.scrollViewPan(contentOffset: let offset, maxVerticalOffset: let maxOffset):
            return offset >= maxOffset ? DetentFactory.fullScreenState : nil
        }
    }
}


