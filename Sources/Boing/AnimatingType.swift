//
//  AnimatingType.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

/// The core animation types available to perform.
///
/// Each animation type may have associated values that
/// define how the animation will execute. These are relevant
/// to the specific animation type.
///
/// - Attention: Some animations may conflict with others and
///              have undefined behavior.
///
/// - Note: More animatatable properties exist and
///         may be added in the future. See [here](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html)
public enum AnimatingType {
    
    // Basic
    case translate(CGFloat, CGFloat)
    case scale(CGFloat, CGFloat)
    case rotate(CGFloat)
    case anchorPoint(CGPoint)
    case backgroundColor(UIColor)
    case cornerRadius(CGFloat)
    case alpha(CGFloat)
    case frame(CGRect)
    case bounds(CGRect)
    case center(CGPoint)
    case size(CGSize)
    case borderColor(UIColor)
    case borderWidth(CGFloat)
    case shadowColor(UIColor)
    case shadowOffset(CGSize)
    case shadowOpacity(CGFloat)
    case shadowRadius(CGFloat)
    case transform(CGAffineTransform)
    case layerTransform(CATransform3D)
    
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
    case identity(TimeInterval)
    case now
    
    var isViewAnimation: Bool {
        switch self {
        case .translate, .scale, .rotate, .backgroundColor, .cornerRadius, .alpha, .frame, .bounds, .center, .size, .transform, .fadeIn, .fadeOut, .zoomIn, .zoomOut, .slide, .fall: return true
        case .squeeze(let direction): return direction != .none
        default: return false
        }
    }
    
    var isLayerAnimation: Bool {
        switch self {
        case .anchorPoint, .borderColor, .borderWidth, .shadowColor, .shadowOffset, .shadowOpacity, .shadowRadius, .layerTransform, .shake, .pop, .flip, .morph, .flash, .wobble, .swing: return true
        case .squeeze(let direction): return direction == .none
        default: return false
        }
    }
    
    var isCustomAnimation: Bool {
        switch self {
        case .boing, .delay, .identity, .now: return true
        default: return false
        }
    }
    
    func applyViewUpdates(for context: AnimatingContext, position: AnimatingPosition) {
        guard let target = context.target else {
            assertionFailure("Animation context cannot have nil target")
            return
        }
        
        switch position {
        case .start:
            switch self {
            case .fadeIn(let direction):
                let original = target.alpha
                context.reset {
                    target.alpha = original
                }
                context.alpha = 0.0
                context.translation = direction.translation
            case .fadeOut:
                let original = target.alpha
                context.reset {
                    target.alpha = original
                }
                context.alpha = 1.0
            case .zoomIn:
                let original = target.alpha
                context.reset {
                    target.alpha = original
                }
                context.alpha = 0.0
                context.scale = CGPoint(x: 2.0, y: 2.0)
            case .zoomOut:
                let original = target.alpha
                context.reset {
                    target.alpha = original
                }
                context.alpha = 1.0
            default:
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
                let original: UIColor? = target.backgroundColor
                context.reset {
                    target.backgroundColor = original
                }
                target.backgroundColor = color
            case .cornerRadius(let radius):
                let original = target.layer.cornerRadius
                context.reset {
                    target.layer.cornerRadius = original
                }
                target.layer.cornerRadius = radius
            case .alpha(let alpha):
                let original = target.alpha
                context.reset {
                    target.alpha = original
                }
                context.alpha = alpha
            case .frame(let frame):
                let original = target.frame
                context.reset {
                    target.frame = original
                }
                target.frame = frame
            case .bounds(let bounds):
                let original = target.bounds
                context.reset {
                    target.bounds = original
                }
                target.bounds = bounds
            case .center(let center):
                let original = target.center
                context.reset {
                    target.center = original
                }
                target.center = center
            case .size(let size):
                let original = target.frame
                context.reset {
                    target.frame = original
                }
                let origin = target.frame.origin
                target.frame = CGRect(origin: origin, size: size)
            case .transform(let transform):
                let original = target.transform
                context.reset {
                    target.transform = original
                }
                target.transform = transform
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
                context.scale = CGPoint(x: 0.5, y: 0.5)
            case .zoomOut:
                context.alpha = 0.0
                context.scale = CGPoint(x: 2.0, y: 2.0)
            case .fall:
                context.translation = CGPoint(x: 0, y: 400)
                context.rotation = 45
            default:
                break
            }
        }
    }
    
    func applyLayerUpdates(for context: AnimatingContext) {
        guard let target = context.target else {
            assertionFailure("Animation context cannot have nil target")
            return
        }
        
        switch self {
        case .anchorPoint(let point): context.layerAnimations.append(basicAnimation(context, keyPath: "anchorPoint", toValue: point, breadcrumb: { target.layer.anchorPoint = point }))
        case .borderColor(let color): context.layerAnimations.append(basicAnimation(context, keyPath: "borderColor", toValue: color.cgColor, breadcrumb: { target.layer.borderColor = color.cgColor }))
        case .borderWidth(let width): context.layerAnimations.append(basicAnimation(context, keyPath: "borderWidth", toValue: width, breadcrumb: { target.layer.borderWidth = width }))
        case .shadowColor(let color): context.layerAnimations.append(basicAnimation(context, keyPath: "shadowColor", toValue: color.cgColor, breadcrumb: { target.layer.shadowColor = color.cgColor }))
        case .shadowOffset(let offset): context.layerAnimations.append(basicAnimation(context, keyPath: "shadowOffset", toValue: offset, breadcrumb: { target.layer.shadowOffset = offset }))
        case .shadowOpacity(let opacity): context.layerAnimations.append(basicAnimation(context, keyPath: "shadowOpacity", toValue: opacity, breadcrumb: { target.layer.opacity = Float(opacity) }))
        case .shadowRadius(let radius): context.layerAnimations.append(basicAnimation(context, keyPath: "shadowRadius", toValue: radius, breadcrumb: { target.layer.shadowRadius = radius }))
        case .layerTransform(let transform): context.layerAnimations.append(basicAnimation(context, keyPath: "transform", toValue: transform, breadcrumb: { target.layer.transform = transform }))
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
        default:
            break
        }
    }
    
    func applyCustomUpdates(for context: AnimatingContext) {
        guard let target = context.target else {
            assertionFailure("Animation context cannot have nil target")
            return
        }
        
        switch self {
        case .boing:
            context.customAnimations.append { completion in
                context.animate(duration: context.duration / 8, delay: 0, damping: 1, velocity: 0, options: [.beginFromCurrentState, context.curve.asOptions()], animations: {
                    target.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                }) {
                    context.animate(duration: 7 * context.duration / 8, animations: {
                        target.transform = .identity
                    }, completion: completion)
                }
            }
        case .delay(let time):
            context.customAnimations.append { completion in
                guard !context.noAnimate else {
                    completion?()
                    return
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                    completion?()
                }
            }
        case .identity(let time):
            context.customAnimations.append { completion in
                let transform = target.transform
                let layerTransform = target.layer.transform
                context.reset {
                    target.transform = transform
                    target.layer.transform = layerTransform
                }
                guard !context.noAnimate else {
                    target.transform = .identity
                    target.layer.transform = CATransform3DIdentity
                    completion?()
                    return
                }
                context.animate(duration: time, delay: 0, damping: 1, velocity: 0, options: [.beginFromCurrentState, context.curve.asOptions()], animations: {
                    target.transform = .identity
                    target.layer.transform = CATransform3DIdentity
                }, completion: completion)
            }
        case .now:
            break
        default:
            break
        }
    }
    
    private func basicAnimation(_ context: AnimatingContext, keyPath: String, fromValue: Any? = nil, toValue: Any?, breadcrumb: (() -> ())? = nil) -> CABasicAnimation {
        let animation = CABasicAnimation()
        animation.keyPath = keyPath
        if let fromValue = fromValue {
            animation.fromValue = fromValue
        }
        animation.toValue = toValue
        if let breadcrumb = breadcrumb {
            context.persist(breadcrumb: breadcrumb)
        }
        return animation
    }
    
}

extension AnimatingType: Nameable {
    
    public var name: String {
        switch self {
        case .translate: return "translate"
        case .scale: return "scale"
        case .rotate: return "rotate"
        case .anchorPoint: return "anchorPoint"
        case .backgroundColor: return "backgroundColor"
        case .cornerRadius: return "cornerRadius"
        case .alpha: return "alpha"
        case .frame: return "frame"
        case .bounds: return "bounds"
        case .center: return "center"
        case .size: return "size"
        case .borderColor: return "borderColor"
        case .borderWidth: return "borderWidth"
        case .shadowColor: return "shadowColor"
        case .shadowOffset: return "shadowOffset"
        case .shadowOpacity: return "shadowOpacity"
        case .shadowRadius: return "shadowRadius"
        case .transform: return "transform"
        case .layerTransform: return "layerTransform"
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
        case .identity: return "identity"
        case .now: return "now"
        }
    }
    
}

extension AnimatingType: CaseIterable {
    
    public static var allCases: [AnimatingType] {
        return [.translate(0, 0), .scale(0, 0), .rotate(0), .anchorPoint(.zero), .backgroundColor(.clear), .cornerRadius(0), .alpha(0), .frame(.zero), .bounds(.zero), .center(.zero), .size(.zero), .borderColor(.clear), .borderWidth(0), .shadowColor(.clear), .shadowOffset(.zero), .shadowOpacity(0), .shadowRadius(0), .transform(.identity), .layerTransform(CATransform3DIdentity), .fadeIn(.none), .fadeOut(.none), .slide(.none), .squeeze(.none), .zoomIn, .zoomOut, .fall, .shake, .pop, .flip(.none), .morph, .flash, .wobble, .swing, .boing, .delay(0), .identity(0), .now]
    }
    
}

extension AnimatingType: Hashable {
    public static func == (lhs: AnimatingType, rhs: AnimatingType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        
        switch self {
        case .translate(let x, let y):
            hasher.combine(x)
            hasher.combine(y)
        case .scale(let x, let y):
            hasher.combine(x)
            hasher.combine(y)
        case .rotate(let angle):
            hasher.combine(angle)
        case .anchorPoint(let point):
            hasher.combine("\(point)")
        case .backgroundColor(let color):
            hasher.combine(color)
        case .cornerRadius(let radius):
            hasher.combine(radius)
        case .alpha(let alpha):
            hasher.combine(alpha)
        case .frame(let frame):
            hasher.combine("\(frame)")
        case .bounds(let bounds):
            hasher.combine("\(bounds)")
        case .center(let point):
            hasher.combine("\(point)")
        case .size(let size):
            hasher.combine("\(size)")
        case .borderColor(let color):
            hasher.combine(color)
        case .borderWidth(let width):
            hasher.combine(width)
        case .shadowColor(let color):
            hasher.combine(color)
        case .shadowOffset(let offset):
            hasher.combine("\(offset)")
        case .shadowOpacity(let opacity):
            hasher.combine(opacity)
        case .shadowRadius(let radius):
            hasher.combine(radius)
        case .transform(let transform):
            hasher.combine("\(transform)")
        case .layerTransform(let transform):
            hasher.combine("\(transform)")
        case .fadeIn(let direction):
            hasher.combine(direction)
        case .fadeOut(let direction):
            hasher.combine(direction)
        case .slide(let direction):
            hasher.combine(direction)
        case .squeeze(let direction):
            hasher.combine(direction)
        case .flip(let direction):
            hasher.combine(direction)
        default:
            break
        }
    }
    
}
