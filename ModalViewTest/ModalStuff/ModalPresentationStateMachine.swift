//
//  ModalPresentationStateMachine.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/5/23.
//

import Foundation
import UIKit


//PresentationController: declares a animator and gives it self presentedView + scrollView to it, and a transitionStateMachine which gets the transitionAnimator which is its delegate.

//MARK: PC -> StateMachine, DetentAnimator,
//MARK: DetentAnimator -> PC
                   


protocol EventProtocol {
    
}

protocol StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate)
    // input could be even a recognizer ...
    func routeBasedOn(event: EventProtocol) -> StateProtocol?
}

protocol StateMachineAnimatorDelegate: AnyObject {
    func animateTransitionToSize(_ size: PresentationDetent)
}

class ModalDetentStateMachine {
        
    var currentState: StateProtocol
    
    weak var animatorDelegate: StateMachineAnimatorDelegate?
        
    init(initialState: StateProtocol) {
        self.currentState = initialState
    }
    
    func handleNextState(basedOn event: EventProtocol) {

        if let nextState = currentState.routeBasedOn(event: event) {
            guard let animator = animatorDelegate else { return }
            nextState.performTransition(with: animator)
            currentState = nextState
        }
    }
}

class DetentAnimationTransition: StateMachineAnimatorDelegate {
    
    var presentationController: PresentationController
    
    func animateTransitionToSize(_ size: PresentationDetent) {
        
        presentationController.configuration.sizeMode = size
        
        UIView.animate(withDuration: 0.45, animations: { [weak self] in
            var newSize: CGSize
            
            guard let self = self else { return }
            switch size  {
            case .fullScreen:
                newSize = presentationController.presentedViewSize(basedOn: .fullScreen)
            case .compact, .short:
                if let scrollView = presentationController.presentable?.scView {
                    let target = CGPoint(x: scrollView.contentOffset.x, y: -(presentationController.presentable?.navigationController?.navigationBar.frame.maxY ?? .zero))
                    scrollView.setContentOffset(target, animated: true)
                }
                newSize = presentationController.presentedViewSize(basedOn: size)
            }
            presentationController.presentedView?.frame = presentationController.presentedViewFrame(basedOn: presentationController.configuration.direction, size: newSize)
        })
    }
    
    init(presentationController: PresentationController) {
        self.presentationController = presentationController
    }
}


//MARK: - States ...

struct FullScreenState: StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate) {
        animator.animateTransitionToSize(.fullScreen)
    }
    
    func routeBasedOn(event: EventProtocol) -> StateProtocol? {
        
        guard let event = event as? ModalTransitionEvents else {return self}
        
        //refactor with if case
        switch event {
        case .contentViewPan(translationY: let translation),
                .navBarPan(translationY: let translation):
            if translation >= 0.001 {
                return DetentFactory.compactState
            }else {
                return self
            }
        default:
            return self
        }
    }
}

struct ShortConstantState: StateProtocol {
    
    func performTransition(with animator: StateMachineAnimatorDelegate) {
        animator.animateTransitionToSize(.short)
    }
    
    func routeBasedOn(event: EventProtocol) -> StateProtocol? {
        
        guard let event = event as? ModalTransitionEvents else {return self}
        
        //refactor with if case
        
        switch event {
        case .contentViewPan(translationY: let translation),
                .navBarPan(translationY: let translation):
            if translation >= 0.001 {
                return DetentFactory.compactState
            }else {
                return self
            }
        case.scrollViewPan(contentOffset: let offset, maxVerticalOffset: let maxOffset, isScrollingUpward: let isScrollingUp):
            if isScrollingUp && offset >= maxOffset {
                return DetentFactory.compactState
            }else {
                return self
            }
        }
    }
}
    
    struct CompactState: StateProtocol {
        
        func performTransition(with animator: StateMachineAnimatorDelegate) {
            animator.animateTransitionToSize(.compact)
        }
        
        func routeBasedOn(event: EventProtocol) -> StateProtocol? {
           
            guard let event = event as? ModalTransitionEvents else {return self}
                    
                    //refactor with if case
                    switch event {
                    case .contentViewPan(translationY: let translation),
                            .navBarPan(translationY: let translation):
                        if translation >= 0.001 {
                            return DetentFactory.fullScreenState
                        }else {
                            return DetentFactory.shortScreenState
                        }
                    case.scrollViewPan(contentOffset: let offset, maxVerticalOffset: let maxOffset, isScrollingUpward: let isScrollingUp):
                        if isScrollingUp && offset >= maxOffset {
                            return DetentFactory.fullScreenState
                        }else {
                            return DetentFactory.shortScreenState
                        }
                    }
            }
    }
    
    
    
    enum ModalTransitionEvents: EventProtocol {
        
        case scrollViewPan(contentOffset: CGFloat, maxVerticalOffset: CGFloat, isScrollingUpward: Bool)
        case navBarPan(translationY: CGFloat)
        case contentViewPan(translationY: CGFloat)
    }
    
    struct DetentFactory {
        static var compactState = CompactState()
        static var fullScreenState = FullScreenState()
        static var shortScreenState = ShortConstantState()
}


struct IDK {
    static func mapState(Detent: PresentationDetent) -> StateProtocol {
        switch Detent {
        case .compact:
            return DetentFactory.compactState
        case .fullScreen:
            return DetentFactory.fullScreenState
        case .short:
            return DetentFactory.shortScreenState
        }
    }
}
