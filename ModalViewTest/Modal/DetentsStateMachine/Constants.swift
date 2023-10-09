//
//  Constants.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/9/23.
//

import Foundation

struct DetentFactory {
    
    static var compactState = CompactState()
    static var fullScreenState = FullScreenState()
    static var shortScreenState = ShortConstantState()
    
    static func state(Of detent: PresentationDetent) -> StateProtocol {
        switch detent {
        case .compact:
            return DetentFactory.compactState
        case .fullScreen:
            return DetentFactory.fullScreenState
        case .short:
            return DetentFactory.shortScreenState
        }
    }
}

