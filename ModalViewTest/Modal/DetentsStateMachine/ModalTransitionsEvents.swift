//
//  Enums.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation


//MARK: - Events and Constants

enum ModalTransitionEvents {
    
    case scrollViewPan(contentOffset: CGFloat, maxVerticalOffset: CGFloat)
    case navBarPan(translationY: CGFloat)
    case interactivePan(velocityY: CGFloat)
}
