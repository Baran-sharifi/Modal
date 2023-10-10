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
    
    func handleNextState(basedOn event: EventProtocol) {
        print("handle state is called.")
        if animationCompleted {
            if let nextState = currentState.routeBasedOn(event: event) {
                guard let animator = animatorDelegate else { return }
                nextState.performTransition(with: animator)
                currentState = nextState
            }
        }
    }
}
