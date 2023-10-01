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
            return isHeightInteractive ?  400.0 : longHeight
        }
        
        var longHeight: CGFloat {
            
            return scrollViewMaxHeight ?? view.safeAreaLayoutGuide.layoutFrame.height
        }
        
        var compactHeight: CGFloat?
        
        var scrollViewMaxHeight: CGFloat?
        
        var scrollView: UIScrollView = UIScrollView()
        
        init(isHeightInteractive: Bool) {
            self.isHeightInteractive = isHeightInteractive
            
            super.init(nibName: nil, bundle: nil)
        }
        
        required public init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func viewDidLayoutSubviews() {
            
            let screenUsableHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
            scrollViewMaxHeight = min(screenUsableHeight, scrollView.contentSize.height)
        }
}
