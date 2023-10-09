//
//  Views.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 9/28/23.
//

import UIKit

class DimmedView: UIView {
    
    enum AlphaState {
        
        case transparent
        case percent(CGFloat)
        case maxShadow
    }
    
    public var state: AlphaState = .transparent {
        didSet{
            applyTransparency(state)
        }
    }
    
    public var dismissPresenting: ((_ recognizer: UIGestureRecognizer) -> Void)?


    private lazy var tapGesture: UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
    }()

    init(state: AlphaState) {
        
        super.init(frame: .zero)
        backgroundColor = .gray
        self.state = state
        applyTransparency(state)
        addGestureRecognizer(tapGesture)
    }
    
    func applyTransparency(_ state: AlphaState) {
        switch state {
        case .transparent:
            alpha = 0
        case .percent(let value):
            alpha = value
            print(alpha)
        case .maxShadow:
            alpha = 1
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc private func tapHandler(_: UIGestureRecognizer) {
        dismissPresenting?(tapGesture)
    }
}

