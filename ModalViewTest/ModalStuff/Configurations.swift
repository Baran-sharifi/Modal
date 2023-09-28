//
//  Configurations.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation

struct PresentationConfiguration {
    
    var isBackViewInteractable: Bool
    var isInteractiveSizeSupported: Bool

    var dimmingState: DimmedView.AlphaState
    
    var direction: PresentingDirection
    var sizeMode: PresentationDetent
    
    init(isBackViewInteractable: Bool = false, isInteractiveSizeSupported: Bool = false, dimmingState: DimmedView.AlphaState = .percent(0.5), direction: PresentingDirection, sizeMode: PresentationDetent) {
        self.isBackViewInteractable = isBackViewInteractable
        self.isInteractiveSizeSupported = isInteractiveSizeSupported
        self.dimmingState = dimmingState
        self.direction = direction
        self.sizeMode = sizeMode
    }
}



struct PresentationStyle {
    
    var bottomSheet: PresentationConfiguration = PresentationConfiguration(isBackViewInteractable: true, isInteractiveSizeSupported: true, direction: .bottom, sizeMode: .interactive)
    
    var leftPageSheet: PresentationConfiguration = PresentationConfiguration(isBackViewInteractable: true, isInteractiveSizeSupported: true, direction: .left, sizeMode: .interactive)
}
