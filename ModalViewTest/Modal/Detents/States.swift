//
//  States.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation

protocol StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate)
    func routeBasedOn(event: ModalDetentAnimationEvents) -> StateProtocol?
}

struct FullScreenState: StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate) {
        animator.animateTransitionToSize(.fullScreen)
    }
    
    func routeBasedOn(event: ModalDetentAnimationEvents) -> StateProtocol? {
        
        switch event {
        case .navBarPan(translationY: let translation):
            return translation >= 0.001 ? DetentFactory.compactState : self
        default:
            return nil
        }
    }
}

struct ShortConstantState: StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate) {
        animator.animateTransitionToSize(.short)
    }
    
    func routeBasedOn(event: ModalDetentAnimationEvents) -> StateProtocol? {
        
        switch event {
        case .navBarPan(translationY: let translation):
            return translation <= -0.001 ? DetentFactory.compactState : self
        case.scrollViewPan(contentOffset: let offset, maxVerticalOffset: let maxOffset):
            return offset >= maxOffset ? DetentFactory.compactState : self
        case .interactivePan(velocityY: _):
            return nil
        }
    }
}

struct CompactState: StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate) {
        animator.animateTransitionToSize(.compact)
    }
    
    func routeBasedOn(event: ModalDetentAnimationEvents) -> StateProtocol? {
        
        switch event {
        case .navBarPan(translationY: let translation):
            return translation <= -0.001 ? DetentFactory.fullScreenState : DetentFactory.shortScreenState
        case.scrollViewPan(contentOffset: let offset, maxVerticalOffset: let maxOffset):
            return offset >= maxOffset ? DetentFactory.fullScreenState : nil
        case .interactivePan(velocityY: _):
            return nil
        }
    }
}


