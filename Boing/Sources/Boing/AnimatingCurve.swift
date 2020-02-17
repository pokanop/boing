//
//  AnimatingCurve.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

/// The curve to use in `AnimatingType` values.
public enum AnimatingCurve: CaseIterable {
    
    case linear, easeIn, easeOut, easeInOut
    case custom(CGPoint, CGPoint)
    
    public static var allCases: [AnimatingCurve] {
        return [.linear, .easeIn, .easeOut, .easeInOut, .custom(.zero, .zero)]
    }
    
    func asOptions() -> UIView.AnimationOptions {
        switch self {
        case .easeIn: return .curveEaseIn
        case .easeOut: return .curveEaseOut
        case .easeInOut: return .curveEaseInOut
        case .linear: return .curveLinear
        case .custom: return .curveLinear
        }
    }
    
    func asTimingFunction() -> CAMediaTimingFunction {
        switch self {
        case .easeIn: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        case .linear: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .custom(let cp1, let cp2): return CAMediaTimingFunction(controlPoints: Float(cp1.x), Float(cp1.y), Float(cp2.x), Float(cp2.y))
        }
    }
    
}

extension AnimatingCurve: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        if case .custom(let p1, let p2) = self {
            hasher.combine("\(p1)")
            hasher.combine("\(p2)")
        }
    }
    
}

extension AnimatingCurve: Nameable {
    
    /// The name of the curve.
    public var name: String {
        switch self {
        case .easeIn: return "easeIn"
        case .easeOut: return "easeOut"
        case .easeInOut: return "easeInOut"
        case .linear: return "linear"
        case .custom: return "custom"
        }
    }
    
}
