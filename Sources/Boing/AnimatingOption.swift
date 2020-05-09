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
    
    /// delay before next animation
    case delay(TimeInterval)
    /// duration of the animation
    case duration(TimeInterval)
    /// curve to use for the animation
    case curve(AnimatingCurve)
    /// damping value to use for the animation
    case damping(CGFloat)
    /// velocity of the animation
    case velocity(CGFloat)
    /// number of times to repeat the animation
    case repeatCount(Float)
    /// whether to reverse the animation at the end
    case autoreverse(Bool)
    /// whether to persist transforms or remove at the end
    case removeOnCompletion(Bool)
    /// whether to apply transforms only without animation
    case noAnimate(Bool)
    
    public static var allCases: [AnimatingOption] {
        return [.delay(0), .duration(0), .curve(.easeInOut), .damping(0), .velocity(0), .repeatCount(0), .autoreverse(false), .removeOnCompletion(true), .noAnimate(false)]
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
        case .noAnimate: return "noAnimate"
        }
    }
    
}
