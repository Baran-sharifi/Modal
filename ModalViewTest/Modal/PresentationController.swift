//
//  PresentationController.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

public class PresentationController: UIPresentationController {
    
    private lazy var transitionStateMachine: ModalDetentStateMachine = {
        let machine = ModalDetentStateMachine(initialState: DetentFactory.state(Of: configuration.sizeMode))
        machine.animatorDelegate = animationDelegate
        return machine
    }()
    
    private lazy var animationDelegate: DetentAnimationDelegate = DetentAnimationDelegate(presentationController: self)
    
    internal var configuration: PresentationControllerConfiguration
    
    private lazy var dimmingView: DimmedView = DimmedView(state: .percent(0.1))
    
    internal lazy var presentable: PresentableViewController? = {
        
        if let presentedVC = (presentedViewController as? UINavigationController) {
            return presentedVC.viewControllers.first as? PresentableViewController
        } else {
            return presentedViewController as? PresentableViewController
        }
    }()
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        
        let size = presentedViewSize(basedOn: configuration.sizeMode)
        return presentedViewFrame(basedOn: configuration.direction, size: size)
    }
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         configuration: PresentationControllerConfiguration) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    internal func presentedViewSize(basedOn detent: PresentationDetent) -> CGSize {
        
        let containerViewBounds = containerView?.bounds ?? CGRect.zero
        
        var size: CGSize = .zero
        guard let presentable = presentable else { return CGSize.init(width: 200, height: 200) }
        
        switch detent {
        case .fullScreen:
            size = CGSize.init(width: containerViewBounds.width, height: presentable.fullScreenHeight)
        case .short:
            size = CGSize.init(width: containerViewBounds.width, height: presentable.shortHeight)
        case .compact:
            size = CGSize.init(width: containerViewBounds.width, height: presentable.compactHeight)
        }
        return size
    }
    
    internal func presentedViewFrame(basedOn direction: PresentingDirection, size: CGSize) -> CGRect {
        
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
        
        if configuration.isInteractiveSizeSupported {
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            panGestureRecognizer.delegate = self
            presentable?.view.isUserInteractionEnabled = true
            presentable?.view.addGestureRecognizer(panGestureRecognizer)
            let navbarPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleNavBarGesture(_:)))
            presentable?.navigationController?.navigationBar.addGestureRecognizer(navbarPanGestureRecognizer)
            presentable?.navigationController?.navigationBar.isUserInteractionEnabled = true
        }
    }
    
    func normalizedVelocity(recognizer: UIPanGestureRecognizer) -> CGFloat {
        let yVelocity = recognizer.velocity(in: self.presentable?.navigationController?.navigationBar).y
        return -(yVelocity / 50)
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        if configuration.isInteractiveSizeSupported && recognizer.state == .ended {
            if let scrollView = self.presentable?.scView {
                let maxOffset = scrollView.contentSize.height - scrollView.bounds.height
                transitionStateMachine.handleNextState(basedOn: ModalDetentAnimationEvents.scrollViewPan(contentOffset: scrollView.contentOffset.y, maxVerticalOffset: maxOffset))
            }
        }
    }
    
    @objc func handleNavBarGesture(_ recognizer: UIPanGestureRecognizer) {
        
        if configuration.isInteractiveSizeSupported {
            
            switch recognizer.state {
            case .began, .changed:
                let velocity = normalizedVelocity(recognizer: recognizer)
                transitionStateMachine.handleNextState(basedOn: .interactivePan(velocityY: velocity))
            case .ended, .cancelled, .failed:
                let translation = recognizer.translation(in: self.presentable?.navigationController?.navigationBar).y
                transitionStateMachine.handleNextState(basedOn: .navBarPan(translationY: translation))
            default:
                break
            }
        }
    }
}

extension PresentationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view?.frame == self.presentable?.navigationController?.navigationBar.frame {
            return false
        } else {
            return true
        }
    }
}

struct PresentationControllerConfiguration {
    
    var isBackViewInteractable: Bool
    var isInteractiveSizeSupported: Bool

    var dimmingState: DimmedView.AlphaState
    
    var direction: PresentingDirection
    var sizeMode: PresentationDetent
    
    init(isBackViewInteractable: Bool = false, isInteractiveSizeSupported: Bool = false, dimmingState: DimmedView.AlphaState = .transparent, direction: PresentingDirection, sizeMode: PresentationDetent) {
        self.isBackViewInteractable = isBackViewInteractable
        self.isInteractiveSizeSupported = isInteractiveSizeSupported
        self.dimmingState = dimmingState
        self.direction = direction
        self.sizeMode = sizeMode
    }
}

