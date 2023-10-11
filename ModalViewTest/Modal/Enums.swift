//
//  Enums.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation

public enum ModalPresentationAnimationState {
    
    case presentation
    case dismissal
}

public enum PresentingDirection {
    
    // do we ever need a dismissal in same direction of presentation?
    
    case left
    case right
    case top
    case bottom
}

public enum PresentationDetent {
    
    case short
    case compact
    case fullScreen
}
