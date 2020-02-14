//
//  AnimatingOption.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

public enum AnimatingOption: CaseIterable {
    
    case delay(TimeInterval)
    case duration(TimeInterval)
    case curve(AnimatingCurve)
    case damping(CGFloat)
    case velocity(CGFloat)
    case repeatCount(Float)
    case autoreverse(Bool)
    
    public static var allCases: [AnimatingOption] {
        return [.delay(0), .duration(0), .curve(.easeInOut), .damping(0), .velocity(0), .repeatCount(0), .autoreverse(false)]
    }
    
}

extension AnimatingOption: Nameable {
    
    public var name: String {
        switch self {
        case .delay: return "delay"
        case .duration: return "duration"
        case .curve: return "curve"
        case .damping: return "damping"
        case .velocity: return "velocity"
        case .repeatCount: return "repeatCount"
        case .autoreverse: return "autoreverse"
        }
    }
    
}
