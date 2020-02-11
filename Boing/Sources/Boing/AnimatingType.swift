//
//  File.swift
//  
//
//  Created by Sahel Jalal on 2/10/20.
//

import UIKit

public enum AnimatingOption {
    
    case delay(TimeInterval)
    case duration(TimeInterval)
    case curve(AnimatingCurve)
    case damping(CGFloat)
    case velocity(CGFloat)
    case repeatCount(Float)
    case autoreverse(Bool)
    
}

public enum AnimatingAxis {
    case horizontal, vertical
}

public enum AnimatingCurve {
    
    case linear, easeIn, easeOut, easeInOut
    case custom(CGPoint, CGPoint)
    
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

public enum AnimatingDirection {
    
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

public enum AnimatingPosition {
    case start, end
}



public enum AnimatingType {
    
    // Basic
    case translate(CGFloat, CGFloat)
    case scale(CGFloat, CGFloat)
    case rotate(CGFloat)
    case backgroundColor(UIColor)
    case alpha(CGFloat)
    case frame(CGRect)
    case bounds(CGRect)
    case center(CGPoint)
    
    // Presets
    case fadeIn(AnimatingDirection)
    case fadeOut(AnimatingDirection)
    case slide(AnimatingDirection)
    case squeeze(AnimatingDirection)
    case zoomIn
    case zoomOut
    case fall
    case shake
    case pop
    case flip(AnimatingDirection)
    case morph
    case flash
    case wobble
    case swing
    case boing
    
    // Utilities
    case delay(TimeInterval)
    
    var isViewAnimation: Bool {
        switch self {
        case .translate, .scale, .rotate, .backgroundColor, .alpha, .frame, .bounds, .center, .fadeIn, .fadeOut, .zoomIn, .zoomOut, .slide, .fall: return true
        case .squeeze(let direction): return direction != .none
        case .shake, .pop, .flip, .morph, .flash, .wobble, .swing, .delay, .boing: return false
        }
    }
    
    func apply(_ context: AnimatingContext, position: AnimatingPosition) {
        switch position {
        case .start:
            switch self {
            case .fadeIn(let direction):
                context.alpha = 0.0
                context.translation = direction.translation
            case .fadeOut:
                context.alpha = 1.0
            case .zoomIn:
                context.alpha = 0.0
            case .zoomOut:
                context.alpha = 1.0
            case .shake:
                let animation = CAKeyframeAnimation()
                animation.keyPath = "position.x"
                animation.values = [0, 30, -30, 30, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.isAdditive = true
                context.layerAnimations.append(animation)
            case .pop:
                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale"
                animation.values = [0, 0.2, -0.2, 0.2, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.isAdditive = true
                context.layerAnimations.append(animation)
            case .flip(let direction):
                guard let target = context.target else { return }

                var perspective = CATransform3DIdentity
                perspective.m34 = -1.0 / target.layer.frame.size.width / 2
                
                let animation = CABasicAnimation()
                animation.keyPath = "transform"
                animation.fromValue = NSValue(caTransform3D: CATransform3DMakeRotation(0, 0, 0, 0))
                animation.toValue = NSValue(caTransform3D: CATransform3DConcat(perspective, direction.transform(for: self)))
                context.layerAnimations.append(animation)
            case .morph:
                var animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale.x"
                animation.values = [1, 1.3, 0.7, 1.3, 1]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                context.layerAnimations.append(animation)
                
                animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale.y"
                animation.values = [1, 0.7, 1.3, 0.7, 1]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                context.layerAnimations.append(animation)
            case .squeeze(let direction):
                guard direction == .none else { return }
                
                var animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale.x"
                animation.values = [1, 1.5, 0.5, 1.5, 1]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                context.layerAnimations.append(animation)
                
                animation = CAKeyframeAnimation()
                animation.keyPath = "transform.scale.y"
                animation.values = [1, 0.5, 1, 0.5, 1]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                context.layerAnimations.append(animation)
            case .flash:
                let animation = CABasicAnimation()
                animation.keyPath = "opacity"
                animation.fromValue = 1
                animation.toValue = 0
                animation.autoreverses = true
                context.repeatCount *= 2
                context.layerAnimations.append(animation)
            case .wobble:
                var animation = CAKeyframeAnimation()
                animation.keyPath = "transform.rotation"
                animation.values = [0, 0.3, -0.3, 0.3, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.isAdditive = true
                context.layerAnimations.append(animation)
                
                animation = CAKeyframeAnimation()
                animation.keyPath = "position.x"
                animation.values = [0, 30, -30, 30, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.isAdditive = true
                context.layerAnimations.append(animation)
            case .swing:
                let animation = CAKeyframeAnimation()
                animation.keyPath = "transform.rotation"
                animation.values = [0, 0.3, -0.3, 0.3, 0]
                animation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1]
                animation.isAdditive = true
                context.layerAnimations.append(animation)
            case .delay(let time):
                context.customAnimations.append({ completion in
                    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                        completion?()
                    }
                })
            case .boing:
                guard let target = context.target else { return }
                
                context.customAnimations.append { completion in
                    UIView.animateKeyframes(withDuration: context.duration, delay: context.delay, options: [.beginFromCurrentState, .calculationModeCubic], animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) {
                            target.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.6) {
                            target.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                            target.transform = .identity
                        }
                    }) { _ in
                        completion?()
                    }
                }
            case .translate, .scale, .rotate, .backgroundColor, .alpha, .frame, .bounds, .center, .slide, .fall:
                break
            }
        case .end:
            switch self {
            case .translate(let x, let y):
                context.translation.x = x
                context.translation.y = y
            case .scale(let x, let y):
                context.scale.x = x
                context.scale.y = y
            case .rotate(let angle):
                context.rotation = angle
            case .backgroundColor(let color):
                context.target?.backgroundColor = color
            case .alpha(let alpha):
                context.alpha = alpha
            case .frame(let frame):
                context.target?.frame = frame
            case .bounds(let bounds):
                context.target?.bounds = bounds
            case .center(let center):
                context.target?.center = center
            case .fadeIn(let direction):
                context.alpha = 1.0
                context.translation = direction.translation.negated
            case .fadeOut(let direction):
                context.alpha = 0.0
                context.translation = direction.translation
            case .slide(let direction):
                context.translation = direction.translation
            case .squeeze(let direction):
                guard direction != .none else { return }
                context.scale = direction.scale
                context.translation = direction.translation
            case .zoomIn:
                context.alpha = 1.0
                context.scale = CGPoint(x: 2.0, y: 2.0)
            case .zoomOut:
                context.alpha = 0.0
                context.scale = CGPoint(x: 2.0, y: 2.0)
            case .fall:
                context.translation = CGPoint(x: 0, y: 400)
                context.rotation = 45 * (CGFloat.pi / 180)
            case .shake, .pop, .flip, .morph, .flash, .wobble, .swing, .delay, .boing:
                break
            }
        }
    }
    
}