//
//  PresentationController.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

open class PresentationController: UIPresentationController, UIGestureRecognizerDelegate {
    
    private var configuration: PresentationConfiguration
    
    private var dimmingView: DimmedView!
    
    private var presentable: PresentableViewController? {
        return presentedViewController as? PresentableViewController
    }
    
    open override var frameOfPresentedViewInContainerView: CGRect { // works fine
        
        let containerViewBounds = containerView?.bounds ?? CGRect.zero
        
        var size: CGSize = .zero
        
        switch configuration.sizeMode {
        case .long:
            size = CGSize.init(width: containerViewBounds.width, height: presentable?.longHeight ?? 200)
        case .short:
            size = CGSize.init(width: containerViewBounds.width, height: presentable?.shortHeight ?? 200)
            print(size)
        default :
            //TODO: work on how to have compact mode
            return .zero
        }
        return frame(basedOn: configuration.direction, size: size)
    }
    
    private func frame(basedOn direction: PresentingDirection, size: CGSize) -> CGRect{
        
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
    
    open override func presentationTransitionWillBegin() {
        
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
    
    open override func presentationTransitionDidEnd(_ completed: Bool) {}
    
    open override func dismissalTransitionWillBegin() {
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] context in
                self?.dimmingView.state = .transparent
            })
        } else {
            dimmingView.state = .transparent
        }
    }
    
    open override func dismissalTransitionDidEnd(_ completed: Bool){}
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         configuration: PresentationConfiguration) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmedView()
    }
    
    
    func transitionToSize(_ size: PresentationDetent) {
        
        configuration.sizeMode = size
        containerView?.setNeedsLayout()
    }
    
    func setupDimmedView() {
        
        guard let containerView = containerView else { return }
        
        dimmingView = DimmedView(state: configuration.dimmingState)
        
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
        containerView?.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer){
        
        if configuration.isInteractiveSizeSupported {
            
            let panTranslation = recognizer.translation(in: presentedView)
            let heightDiff = (presentable?.compactHeight ?? 300) - (presentable?.shortHeight ?? 100)
            
            switch recognizer.state {
            case .began, .changed:
                
                if panTranslation.y < -(presentable?.shortHeight ?? 300)    {
                    transitionToSize(.compact)
                } else if panTranslation.y >= heightDiff {
                    transitionToSize(.short)
                }
                
            default:
                break
            }
        }
    }
    
    // to avoid infrence of other gestures with pan
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer || otherGestureRecognizer is UIPanGestureRecognizer {
            return false
        }
        return true
    }
}
