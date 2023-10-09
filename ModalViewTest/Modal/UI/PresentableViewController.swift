//
//  Presentable.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

@objc protocol PresentableViewControllerProtocol where Self: UIViewController {
    
    var isHeightInteractive: Bool { get set }
    
    var shortHeight: CGFloat { get }
    var fullScreenHeight: CGFloat { get }
    
    var modalTransitionDelegate: UIViewControllerTransitioningDelegate { get set }
    
    @objc optional var fractionalHeightToScreen: CGFloat { get set }
}

open class PresentableViewController: UIViewController, PresentableViewControllerProtocol, UIGestureRecognizerDelegate {
    
    var modalTransitionDelegate: UIViewControllerTransitioningDelegate
    
    var isHeightInteractive: Bool = true
    
    var shortHeight: CGFloat {
        return isHeightInteractive ? 300 : compactHeight
    }
    
    var fullScreenHeight: CGFloat {
        print(self.view.layoutMarginsGuide.layoutFrame.height)
        return self.view.layoutMarginsGuide.layoutFrame.height
    }
    // its the maximum content height considering the insets,
    var compactHeight: CGFloat {
        return min(fullScreenHeight, scView?.contentSize.height ?? 300)
    }
    
    var scrollViewMaxHeight: CGFloat?
    
    var scView: UIScrollView?
    
    init(isHeightInteractive: Bool, modalTransitionDelegate: UIViewControllerTransitioningDelegate) {
        self.isHeightInteractive = isHeightInteractive
        self.modalTransitionDelegate = modalTransitionDelegate
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = modalTransitionDelegate
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLayoutSubviews() {
        
    }
}
