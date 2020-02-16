//
//  AnimatingType.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

public enum AnimatingType {
    
    // Basic
    case translate(CGFloat, CGFloat)
    case scale(CGFloat, CGFloat)
    case rotate(CGFloat)
    case backgroundColor(UIColor)
    case cornerRadius(CGFloat)
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
        case .translate, .scale, .rotate, .backgroundColor, .cornerRadius, .alpha, .frame, .bounds, .center, .fadeIn, .fadeOut, .zoomIn, .zoomOut, .slide, .fall: return true
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
            case .translate, .scale, .rotate, .backgroundColor, .cornerRadius, .alpha, .frame, .bounds, .center, .slide, .fall:
                break
            }
        case .end:
            switch self {
            case .translate(let x, let y):
                context.translation = CGPoint(x: x, y: y)
            case .scale(let x, let y):
                context.scale = CGPoint(x: x, y: y)
            case .rotate(let angle):
                context.rotation = angle
            case .backgroundColor(let color):
                context.target?.backgroundColor = color
            case .cornerRadius(let cornerRadius):
                context.target?.layer.cornerRadius = cornerRadius
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

extension AnimatingType: Nameable {
    
    public var name: String {
        switch self {
        case .translate: return "translate"
        case .scale: return "scale"
        case .rotate: return "rotate"
        case .backgroundColor: return "backgroundColor"
        case .cornerRadius: return "cornerRadius"
        case .alpha: return "alpha"
        case .frame: return "frame"
        case .bounds: return "bounds"
        case .center: return "center"
        case .fadeIn: return "fadeIn"
        case .fadeOut: return "fadeOut"
        case .slide: return "slide"
        case .squeeze: return "squeeze"
        case .zoomIn: return "zoomIn"
        case .zoomOut: return "zoomOut"
        case .fall: return "fall"
        case .shake: return "shake"
        case .pop: return "pop"
        case .flip: return "flip"
        case .morph: return "morph"
        case .flash: return "flash"
        case .wobble: return "wobble"
        case .swing: return "swing"
        case .boing: return "boing"
        case .delay: return "delay"
        }
    }
    
}

extension AnimatingType: CaseIterable {
    
    public static var allCases: [AnimatingType] {
        return [.translate(0, 0), .scale(0, 0), .rotate(0), .backgroundColor(.clear), .cornerRadius(0), .alpha(0), .frame(.zero), .bounds(.zero), .center(.zero), .fadeIn(.none), .fadeOut(.none), .slide(.none), .squeeze(.none), .zoomIn, .zoomOut, .fall, .shake, .pop, .flip(.none), .morph, .flash, .wobble, .swing, .boing]
    }
    
}

extension AnimatingType: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .translate(let x, let y):
            hasher.combine("translate")
            hasher.combine(x)
            hasher.combine(y)
        case .scale(let x, let y):
            hasher.combine("scale")
            hasher.combine(x)
            hasher.combine(y)
        case .rotate(let angle):
            hasher.combine("rotate")
            hasher.combine(angle)
        case .backgroundColor(let color):
            hasher.combine("backgroundColor")
            hasher.combine(color)
        case .cornerRadius(let cornerRadius):
            hasher.combine(cornerRadius)
        case .alpha(let alpha):
            hasher.combine("alpha")
            hasher.combine(alpha)
        case .frame(let frame):
            hasher.combine("frame")
            hasher.combine("\(frame)")
        case .bounds(let bounds):
            hasher.combine("bounds")
            hasher.combine("\(bounds)")
        case .center(let point):
            hasher.combine("center")
            hasher.combine("\(point)")
        case .fadeIn(let direction):
            hasher.combine("fadeIn")
            hasher.combine(direction)
        case .fadeOut(let direction):
            hasher.combine("fadeOut")
            hasher.combine(direction)
        case .slide(let direction):
            hasher.combine("slide")
            hasher.combine(direction)
        case .squeeze(let direction):
            hasher.combine("squeeze")
            hasher.combine(direction)
        case .zoomIn:
            hasher.combine("zoomIn")
        case .zoomOut:
            hasher.combine("zoomOut")
        case .fall:
            hasher.combine("fall")
        case .shake:
            hasher.combine("shake")
        case .pop:
            hasher.combine("pop")
        case .flip(let direction):
            hasher.combine("flip")
            hasher.combine(direction)
        case .morph:
            hasher.combine("morph")
        case .flash:
            hasher.combine("flash")
        case .wobble:
            hasher.combine("wobble")
        case .swing:
            hasher.combine("swing")
        case .boing:
            hasher.combine("boing")
        case .delay: hasher.combine("delay")
        }
    }
    
}
