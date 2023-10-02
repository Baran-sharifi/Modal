//
//  Animator.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

public protocol ModalTransitionAnimatorProtocol: NSObject, UIViewControllerTransitioningDelegate {
    
    var configuration: ModalAnimatorConfiguration { get }
    
    func animateDismissal(transitionContext: UIViewControllerContextTransitioning)
    func animatePresentation(transitionContext: UIViewControllerContextTransitioning)
}

open class ModalTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, ModalTransitionAnimatorProtocol {
    
    /**
     each animator has two styles for two different transitionable states of a ViewController.
     */
    
    public var configuration: ModalAnimatorConfiguration
    
    private lazy var shouldAnimateHeight = configuration.direction == .bottom || configuration.direction == .top
    
    private var feedbackGenerator: UISelectionFeedbackGenerator?
    
    init(configuration: ModalAnimatorConfiguration) {
        self.configuration = configuration
        super.init()
        
        if case.presentation = configuration.style {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        }
    }
    
    open func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedVC = transitionContext.viewController(forKey: .from) else { return }
        let presentedFrame = transitionContext.finalFrame(for: presentedVC)
        
        presentedVC.view.frame = presentedFrame
        
        UIView.animate(withDuration: configuration.transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: .greatestFiniteMagnitude,
                       initialSpringVelocity: 0,
                       options: .allowAnimatedContent,
                       animations: {
            if self.shouldAnimateHeight {
                presentedVC.view.frame.origin.y = self.configuration.direction == .bottom ? presentedFrame.maxY : -presentedFrame.height
            } else {
                presentedVC.view.frame.origin.x = self.configuration.direction == .left ? 0.0 : presentedFrame.maxX
            }
        },completion: { finished in
            presentedVC.removeFromParent()
            transitionContext.completeTransition(finished)
        })
    }
    
    open func animatePresentation(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedVC = transitionContext.viewController(forKey: .to) else { return }
        let presentedFrame = transitionContext.finalFrame(for: presentedVC)
        let containerBounds = transitionContext.containerView.bounds
            
        var initialFrame = presentedFrame
        
        switch configuration.direction {
        case .bottom:
            initialFrame.origin = .init(x: containerBounds.minX, y: containerBounds.maxY)
        case .top:
            initialFrame.origin = .init(x: containerBounds.minX, y: -(presentedFrame.height))
        case .right:
            initialFrame.origin = .init(x: containerBounds.maxX, y: containerBounds.minY)
        case .left:
            initialFrame.origin = .init(x: containerBounds.minX - presentedFrame.width, y: containerBounds.minY)
        }
        presentedVC.view.frame = initialFrame
        
        transitionContext.containerView.addSubview(presentedVC.view)
        
        if configuration.hasHapticFeedback { feedbackGenerator?.selectionChanged() }
        
        UIView.animate(withDuration: configuration.transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: .greatestFiniteMagnitude,
                       initialSpringVelocity: 0,
                       options: .allowAnimatedContent,
                       animations: {
            
            if self.shouldAnimateHeight {
                presentedVC.view.frame.origin.y = presentedFrame.minY
            } else {
                presentedVC.view.frame.origin.x = presentedFrame.minX
            }
        },completion: { [weak self] finished in
            transitionContext.completeTransition(finished)
            self?.feedbackGenerator = nil
        })
    }
    
    open func animateFrame(Yposition: CGFloat, dimmedViewAlpha: CGFloat) {
        
    }
    
    
    
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        configuration.transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // do the animation based on transitionContext and style, and maybe direction...
        switch configuration.style {
        case .dismissal:
            animateDismissal(transitionContext: transitionContext)
        case .presentation:
            animatePresentation(transitionContext: transitionContext)
        }
    } 
}

public struct ModalAnimatorConfiguration {
    
    public var style: ModalTransitionStyle
    public var direction: PresentingDirection
    public var transitionDuration: Double
    public var hasHapticFeedback: Bool
    
    init(style: ModalTransitionStyle, direction: PresentingDirection, transitionDuration: Double, hasHapticFeedback: Bool) {
        self.style = style
        self.direction = direction
        self.transitionDuration = transitionDuration
        self.hasHapticFeedback = hasHapticFeedback
    }
}
