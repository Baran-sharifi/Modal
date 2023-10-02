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
    
    private var configuration: PresentationConfiguration
    
    private lazy var dimmingView: DimmedView = DimmedView(state: .percent(0.1))
    
    private var presentable: PresentedViewController? {
        return presentedViewController as? PresentedViewController
    }
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        
        let size = presentedViewSize(basedOn: configuration.sizeMode)
        return presentedViewFrame(basedOn: configuration.direction, size: size)
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
        
        setupDimmedView()
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
    
    open override func dismissalTransitionDidEnd(_ completed: Bool){}
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         configuration: PresentationConfiguration) {
        self.configuration = configuration
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    func transitionToSize(_ size: PresentationDetent) {
        
        configuration.sizeMode = size
        // TODO: work on gesture
        
        UIView.animate(withDuration: 1, animations: { [weak self] in
            var newSize: CGSize
            
            guard let self = self else { return }
            switch self.configuration.sizeMode {
            case .long:
                newSize = self.presentedViewSize(basedOn: .long)
            case .short:
                newSize = self.presentedViewSize(basedOn: .short)
            default:
                newSize = .zero
            }
            self.presentedView?.frame = self.presentedViewFrame(basedOn: configuration.direction, size: newSize)
        })
        containerView?.setNeedsLayout()
    }
    
    public func delaycreator() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.transitionToSize(.long)
        }
    }
    
    private func setupDimmedView() {
        
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
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        if configuration.isInteractiveSizeSupported {
            
            let heightDiff = (presentable?.compactHeight ?? 300) - (presentable?.shortHeight ?? 100)
            let panTranslation = recognizer.translation(in: presentedView)
            
            switch recognizer.state {
            case .began, .changed:
                if panTranslation.y < -(presentable?.shortHeight ?? 100) {
                    transitionToSize(.long)
                } else if panTranslation.y >= heightDiff {
                    transitionToSize(.short)
                }
            default:
                break
            }
            
        }
    }
    
    // to avoid infrence of other gestures with pan ..
}

extension PresentationController: UIGestureRecognizerDelegate {
    
    //TODO: work on gesture stuff again.
    
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if configuration.sizeMode == .long {
//            return false
//        } else {
//            // allows the pan gesture to get involved.
//            return true
//        }
        
        // gestures are receiveid
//    }
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
       
//        if gestureRecognizer is UIPanGestureRecognizer && configuration.sizeMode == .long {
//            return false
//        }else {
//            return true
//        }
//    }
}
