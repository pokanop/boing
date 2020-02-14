//
//  AnimatingDirection.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

public enum AnimatingDirection: String, CaseIterable {
    
    case none, up, down, left, right
    
    var translation: CGPoint {
        switch self {
        case .none: return CGPoint(x: 0, y: 0)
        case .up: return CGPoint(x: 0, y: -200)
        case .down: return CGPoint(x: 0, y: 200)
        case .left: return CGPoint(x: -200, y: 0)
        case .right: return CGPoint(x: 200, y: 0)
        }
    }
    
    var scale: CGPoint {
        switch self {
        case .none: return CGPoint(x: 1, y: 1)
        case .up, .down: return CGPoint(x: 1, y: 2)
        case .left, .right: return CGPoint(x: 2, y: 1)
        }
    }
    
    func transform(for type: AnimatingType) -> CATransform3D {
        switch type {
        case .flip:
            switch self {
            case .none: return CATransform3DIdentity
            case .up: return CATransform3DMakeRotation(-CGFloat.pi, 1, 0, 0)
            case .down: return CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0)
            case .left: return CATransform3DMakeRotation(-CGFloat.pi, 0, 1, 0)
            case .right: return CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
            }
        default:
            return CATransform3DIdentity
        }
    }
    
}

extension AnimatingDirection: Nameable {
    
    public var name: String {
        rawValue
    }
    
}
