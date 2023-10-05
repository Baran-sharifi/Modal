//
//  PresentationController.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

//TODO: fix dimmed view animation with delay
// check changing height

//This class is meant to be declared with different configurations,

public class PresentationController: UIPresentationController {
    
    private var transitionStateMachine: ModalStateMachine
    
    private var configuration: PresentationConfiguration
    
    private lazy var dimmingView: DimmedView = DimmedView(state: .percent(0.1))
    
    // make lazy
    private var presentable: PresentableViewController? {
        
        if let presentedVC = presentedViewController as? ModalNavigationController {
            return presentedVC.currentPresentableViewController as? PresentableViewController
        } else {
            return presentedViewController as? PresentedViewController
        }
    }
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        
        let size = presentedViewSize(basedOn: configuration.sizeMode)
        return presentedViewFrame(basedOn: configuration.direction, size: size)
    }
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         configuration: PresentationConfiguration, transitionStateMachine: ModalStateMachine) {
        self.configuration = configuration
        self.transitionStateMachine = transitionStateMachine
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    private func presentedViewSize(basedOn detent: PresentationDetent) -> CGSize {
        
        let containerViewBounds = containerView?.bounds ?? CGRect.zero
        
        var size: CGSize = .zero
        guard let presentable = presentable else {return CGSize.init(width: 200, height: 200)}
        
        switch detent {
        case .long:
            size = CGSize.init(width: containerViewBounds.width, height: presentable.longHeight)
        case .short:
            size = CGSize.init(width: containerViewBounds.width, height: presentable.shortHeight)
        default:
            //TODO: work on how to have compact mode
            break
        }
        return size
    }
    
    private func presentedViewFrame(basedOn direction: PresentingDirection, size: CGSize) -> CGRect {
        
        var origin = CGPoint.zero
        let containerBounds = containerView?.bounds ?? CGRect.zero
        
        switch direction {
        case.bottom:
            origin = .init(x: containerBounds.minX, y: containerBounds.maxY - size.height)
        case .top:
            origin = .init(x: containerBounds.minX, y: containerBounds.minY + size.height)
        case .right:
            origin = .init(x: containerBounds.maxX - size.width, y: containerBounds.minY)
        case .left:
            origin = .init(x: containerBounds.minX, y: containerBounds.minY)
        }
        return CGRect(origin: origin, size: size)
    }
    
    public override func presentationTransitionWillBegin() {
        
        dimmedViewSetup()
        gestureSetup()
        
        if configuration.isBackViewInteractable {
            presentingViewController.view.isUserInteractionEnabled = true
        }
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] context in
                self?.dimmingView.state = .maxShadow
            })
        } else {
            dimmingView.state = .maxShadow
        }
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {}
    
    public override func dismissalTransitionWillBegin() {
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] context in
                self?.dimmingView.state = .transparent
            })
        } else {
            dimmingView.state = .transparent
        }
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool){ }
    
    func animateTransitionToSize(_ size: PresentationDetent) {
        
        configuration.sizeMode = size
        UIView.animate(withDuration: 0.45, animations: { [weak self] in
            var newSize: CGSize
            
            guard let self = self else { return }
            switch self.configuration.sizeMode {
            case .long:
                newSize = self.presentedViewSize(basedOn: .long)
            case .short:
                if let scrollView = self.presentable?.scView {
                    let target = CGPoint(x: scrollView.contentOffset.x, y: -(presentable?.navigationController?.navigationBar.frame.maxY ?? .zero))
                    scrollView.setContentOffset(target, animated: true)
                }
                newSize = self.presentedViewSize(basedOn: .short)
            default:
                newSize = .zero
            }
            self.presentedView?.frame = self.presentedViewFrame(basedOn: configuration.direction, size: newSize)
        })
    }
    
    public func delaycreator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animateTransitionToSize(.long)
        }
    }
    
    private func dimmedViewSetup() {
        
        guard let containerView = containerView else { return }
        
        dimmingView.dismissPresenting = { [weak self] _ in
            self?.presentedViewController.dismiss(animated: true, completion: nil)
        }
        
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dimmingView)
        dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func gestureSetup() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        presentable?.view.isUserInteractionEnabled = true
        presentable?.view.addGestureRecognizer(panGestureRecognizer)
        let navbarPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleNavBarGesture(_:)))
        presentable?.navigationController?.navigationBar.addGestureRecognizer(navbarPanGestureRecognizer)
        presentable?.navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        if let scrollView = self.presentable?.scView {
            transit(basedOn: scrollView, recognizer: recognizer)
        }
    }
    
    // navbar gesture
    @objc func handleNavBarGesture(_ recognizer: UIPanGestureRecognizer) {
        
        if configuration.isInteractiveSizeSupported {
            
            
            transitionStateMachine.handleNextState(basedOn: ModalTransitionEvents.scrollViewPan(input:  recognizer.translation(in: self.presentable?.navigationController?.navigationBar).y))
            
            
            let translation = recognizer.translation(in: self.presentable?.navigationController?.navigationBar).y
            let shortDestinationCondition = configuration.sizeMode == .long && translation >= 0
            let longDestinationCondition = configuration.sizeMode == .short && translation < 0
            
            if shortDestinationCondition {
                animateTransitionToSize(.short)
            } else if longDestinationCondition {
                animateTransitionToSize(.long)
            }
        }
    }
    
    // scrollView gesture
    func transit(basedOn scrollView: UIScrollView, recognizer: UIPanGestureRecognizer) {
        
        if configuration.isInteractiveSizeSupported {
            
            let maxVerticalOffSet = scrollView.contentSize.height - scrollView.bounds.height
            transitionStateMachine.handleNextState(basedOn: ModalTransitionEvents.scrollViewPan(input: scrollView.contentOffset.y))
        
            
            let transitionInput = (recognizer.translation(in: scrollView).y)

            switch configuration.sizeMode {
            case .long :
                break
            case .short:
                if recognizer.translation(in: scrollView).y < 0 {
                    if scrollView.contentOffset.y >= maxVerticalOffSet {
                        animateTransitionToSize(.long)
                    }
                }
            default:
                break
            }
        }
    }
}

// to avoid infrence of other gestures with pan ...

extension PresentationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // nav bar should not be recognized with scrollView
        if gestureRecognizer.view?.frame == self.presentable?.navigationController?.navigationBar.frame {
            return false
        } else {
            return true
        }
    }
}
