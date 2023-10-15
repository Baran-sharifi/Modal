//
//  Views.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import UIKit

import Foundation
import UIKit

class DimmedView: UIView {
    
    enum AlphaState {
        
        case transparent
        case percent(CGFloat)
        case maxShadow
    }
    
    public var state: AlphaState = .transparent {
        didSet {
            switch state {
            case .transparent:
                alpha = 0
            case .percent(let value):
                alpha = value
            case .maxShadow:
                alpha = 1
            }
        }
    }
    
    private lazy var tapGesture: UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
    }()
    
    init(state: AlphaState) {
        
        super.init(frame: .zero)
        self.state = state
        self.addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public var dismissPresenting: ((_ recognizer: UIGestureRecognizer) -> Void)?
    
    @objc private func tapHandler(_: UIGestureRecognizer) {
        dismissPresenting?(tapGesture)
    }
}
