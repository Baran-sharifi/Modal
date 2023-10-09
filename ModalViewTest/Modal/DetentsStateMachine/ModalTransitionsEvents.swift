//
//  Enums.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation


//MARK: - Events and Constants

protocol EventProtocol {
    
}

enum ModalTransitionEvents: EventProtocol {
    
    case scrollViewPan(contentOffset: CGFloat, maxVerticalOffset: CGFloat)
    case navBarPan(translationY: CGFloat)
}
