//
//  Configurations.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

struct PresentationControllerConfiguration {
    
    var isBackViewInteractable: Bool
    var isInteractiveSizeSupported: Bool

    var dimmingState: DimmedView.AlphaState
    
    var direction: PresentingDirection
    var sizeMode: PresentationDetent
    
    init(isBackViewInteractable: Bool = false, isInteractiveSizeSupported: Bool = false, dimmingState: DimmedView.AlphaState = .transparent, direction: PresentingDirection, sizeMode: PresentationDetent) {
        self.isBackViewInteractable = isBackViewInteractable
        self.isInteractiveSizeSupported = isInteractiveSizeSupported
        self.dimmingState = dimmingState
        self.direction = direction
        self.sizeMode = sizeMode
    }
}
