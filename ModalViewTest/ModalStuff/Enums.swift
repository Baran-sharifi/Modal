//
//  Enums.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation

public enum ModalTransitionStyle {
    
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
    
    // Large and medium are two custom sizes, compact is the one based on content and interactive is both of medium and large toghether
    
    case long
    case short
    case compact
    case interactive
}
