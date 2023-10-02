//
//  Configurations.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import Foundation
import UIKit

struct PresentationConfiguration {
    
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



enum ModalStyle {
   case bottomSheet
}

extension UIViewController {
    
    func getPresented(in style: ModalStyle) {
        if let self = self as? PresentableViewController {
            self.modalPresentationStyle = .custom
            self.modalTransitionDelegate = BottomSheetTransititionDelegate()
        } else {
            return
        }
    }
}



// client code should look somehow like this (options):
//1.  having different delegates for each feature
//2. having different animators, presentationController which are kept in struct
