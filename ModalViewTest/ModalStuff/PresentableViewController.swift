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
    var longHeight: CGFloat { get }
    
    @objc optional var fractionalHeightToScreen: CGFloat { get set }
}

open class PresentableViewController: UIViewController, PresentableViewControllerProtocol {
    
    var isHeightInteractive: Bool = true
    
    var shortHeight: CGFloat {
        return isHeightInteractive ?  100 : longHeight
    }
    
    var longHeight: CGFloat {
            return 400
    }
    
    var compactHeight: CGFloat?
    
    var scrollViewMaxHeight: CGFloat?
        
    init(isHeightInteractive: Bool) {
        self.isHeightInteractive = isHeightInteractive
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLayoutSubviews() {
        
//        let screenUsableHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
//        scrollViewMaxHeight = min(screenUsableHeight, scrollView.contentSize.height)
    }
}

struct Modal {
    
    func bottomsheet(presented: PresentableViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerTransitioningDelegate {
        
        let presentationController = PresentationController(presentedViewController: presented, presenting: presenting, configuration: .init(direction: .bottom, sizeMode: .short))
        
        let dismissalAnimator = ModalTransitionAnimator.init(configuration: .init(style: .dismissal, direction: .left, transitionDuration: 3, hasHapticFeedback: true))
        
        let presentationAnimator = ModalTransitionAnimator.init(configuration: .init(style: .presentation, direction: .left, transitionDuration: 3, hasHapticFeedback: true))
        
        return ModalPresentationDelegate()
    }
}
