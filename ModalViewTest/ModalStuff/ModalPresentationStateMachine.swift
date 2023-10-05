//
//  ModalPresentationStateMachine.swift
//  ModalViewTest
//
//  Created by Baran Sharifi on 10/5/23.
//

import Foundation
import UIKit

protocol EventProtocol: MirrorableEnum {
    
}

protocol StateProtocol {
    
    func performTransition()
    // input could be even a recognizer ...
    func routeBasedOn(eventName: String, input: CGFloat) -> StateProtocol?
}

class ModalStateMachine {
    
    var currentState: StateProtocol
    
    init(initialState: StateProtocol) {
        self.currentState = initialState
    }
    
    func handleNextState(basedOn event: EventProtocol) {
        
        let mirror = event.mirror
        let eventName = mirror.label
        let input = mirror.params.first?.value
        // let condition = mirror.params["condition"]
        if let nextState = currentState.routeBasedOn(eventName: eventName, input: input as? CGFloat ?? 0) {
            nextState.performTransition()
            currentState = nextState
        }
    }
}

protocol MirrorableEnum { }

extension MirrorableEnum {
    
    var mirror: (label: String, params: [String: Any]) {
        get {
            let reflection = Mirror(reflecting: self)
            guard reflection.displayStyle == .enum,
                  let associated = reflection.children.first else {
                return ("\(self)", [:])
            }
            let associatedValue = associated.value
            let values = Mirror(reflecting: associatedValue).children
            var valuesArray = [String: Any]()
            for case let item in values where item.label != nil {
                valuesArray[item.label!] = item.value
            }
            return (associated.label!, valuesArray)
        }
    }
}

//MARK: - SAMPLES

// Does involving events even help or just makes it more complicated? :))

//StateA: ==== Input: x =======> StateB, else returns to itself.
//StateB: ==== Input: Y =======> StateA, else returns to itself.

struct LongState: StateProtocol {
    func performTransition() {
    }
    
    func routeBasedOn(eventName: String, input: CGFloat) -> StateProtocol? {
        return self
    }
}

struct ShortState: StateProtocol {
    func performTransition() {
    }
    
    func routeBasedOn(eventName: String, input: CGFloat) -> StateProtocol? {
        return self
    }
}

enum ModalTransitionEvents: EventProtocol {
    
    case scrollViewPan(input: CGFloat)
    case navBarPan(input: CGFloat)
    case contentViewPan(input: CGFloat)
}
