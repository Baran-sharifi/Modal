//
//  ModalDetentStateMachine.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation

class ModalDetentStateMachine {
    
    var currentState: StateProtocol
    
    private var animationCompleted: Bool {
        return (animatorDelegate?.animationCompleted ?? false)
    }
        
    weak var animatorDelegate: StateMachineAnimatorDelegate?
    
    init(initialState: StateProtocol) {
        self.currentState = initialState
    }
    
    func handleNextState(basedOn event: ModalDetentAnimationEvents) {
        if animationCompleted {
            
            guard let animator = animatorDelegate else { return }
            if case.interactivePan(velocityY: let velocity) = event {
                animator.animateInteractiveHeight(velocity)
            }else {
                if let nextState = currentState.routeBasedOn(event: event) {
                    nextState.performTransition(with: animator)
                    currentState = nextState
                }
            }
        }
    }
}
