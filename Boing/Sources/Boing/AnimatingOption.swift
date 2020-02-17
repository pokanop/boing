//
//  AnimatingOption.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

/// Animating options used in an `AnimatingContext`.
///
/// The options are used for any coalesced set of animations that
/// are contained in an `AnimatingContext`. For example, for
/// an `animate` call that combines several animations, they all
/// will share the same `duration` or `delay` and it will apply
/// to the entire context.
///
/// Multiple contexts will have their own options and apply only to
/// that execution of the animation.
public enum AnimatingOption: CaseIterable {
    
    case delay(TimeInterval)
    case duration(TimeInterval)
    case curve(AnimatingCurve)
    case damping(CGFloat)
    case velocity(CGFloat)
    case repeatCount(Float)
    case autoreverse(Bool)
    case removeOnCompletion(Bool)
    
    public static var allCases: [AnimatingOption] {
        return [.delay(0), .duration(0), .curve(.easeInOut), .damping(0), .velocity(0), .repeatCount(0), .autoreverse(false), .removeOnCompletion(true)]
    }
    
}

extension AnimatingOption: Nameable {
    
    /// The name of the option.
    public var name: String {
        switch self {
        case .delay: return "delay"
        case .duration: return "duration"
        case .curve: return "curve"
        case .damping: return "damping"
        case .velocity: return "velocity"
        case .repeatCount: return "repeatCount"
        case .autoreverse: return "autoreverse"
        case .removeOnCompletion: return "removeOnCompletion"
        }
    }
    
}
