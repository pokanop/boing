//
//  Animating.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit
import QuartzCore

protocol Animating {
    
    @discardableResult func animate(animations: [AnimatingType], options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    // Basic animations
    @discardableResult func translate(x: CGFloat, y: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func scale(x: CGFloat, y: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func rotate(angle: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func backgroundColor(_ color: UIColor, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func alpha(_ alpha: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func frame(_ frame: CGRect, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func bounds(_ bounds: CGRect, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func center(_ center: CGPoint, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    // Preset animations
    @discardableResult func fadeIn(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func fadeOut(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func slide(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func squeeze(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func zoomIn(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func zoomOut(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func fall(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func shake(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func pop(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func flip(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func morph(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func flash(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func wobble(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func swing(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func boing(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    // Utilities
    @discardableResult func delay(time: TimeInterval, completion: (() -> ())?) -> AnimatingContext
    
}

enum AnimatingOption {
    
    case delay(TimeInterval)
    case duration(TimeInterval)
    case curve(AnimatingCurve)
    case damping(CGFloat)
    case velocity(CGFloat)
    case repeatCount(Float)
    case autoreverse(Bool)
    
}

enum AnimatingAxis {
    case horizontal, vertical
}

enum AnimatingCurve {
    
    case linear, easeIn, easeOut, easeInOut
    case custom(CGPoint, CGPoint)
    
    fileprivate func asOptions() -> UIView.AnimationOptions {
        switch self {
        case .easeIn: return .curveEaseIn
        case .easeOut: return .curveEaseOut
        case .easeInOut: return .curveEaseInOut
        case .linear: return .curveLinear
        case .custom: return .curveLinear
        }
    }
    
    fileprivate func asTimingFunction() -> CAMediaTimingFunction {
        switch self {
        case .easeIn: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        case .linear: return CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .custom(let cp1, let cp2): return CAMediaTimingFunction(controlPoints: Float(cp1.x), Float(cp1.y), Float(cp2.x), Float(cp2.y))
        }
    }
    
}

enum AnimatingDirection {
    
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

enum AnimatingPosition {
    case start, end
}

enum AnimatingType {
    
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
    
    fileprivate func apply(_ context: AnimatingContext, position: AnimatingPosition) {
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

class AnimatingContext: NSObject {
    
    var animations: [AnimatingType] = []
    var layerAnimations: [CAAnimation] = []
    var customAnimations: [((() -> ())?) -> ()] = []
    weak var target: UIView?
    var completion: (() -> ())?
    
    var delay: TimeInterval = 0.0
    var duration: TimeInterval = 0.7
    var curve: AnimatingCurve = .easeInOut
    var damping: CGFloat = 0.7
    var velocity: CGFloat = 0.7
    var repeatCount: Float = 1.0
    var autoreverse: Bool = false
    
    var translation: CGPoint = CGPoint(x: 0, y: 0)
    var scale: CGPoint = CGPoint(x: 1, y: 1)
    var rotation: CGFloat = 0
    var alpha: CGFloat?
    
    var options: UIView.AnimationOptions {
        var options: UIView.AnimationOptions = [.beginFromCurrentState, curve.asOptions()]
        if autoreverse {
            options.insert(.autoreverse)
        }
        if repeatCount == .greatestFiniteMagnitude {
            options.insert(.repeat)
        }
        return options
    }
    
    private var prev: AnimatingContext?
    private var next: AnimatingContext?
    
    private var hasViewAnimations: Bool {
        return animations.filter({ $0.isViewAnimation }).count > 0
    }
    
    private var hasLayerAnimations: Bool {
        return !layerAnimations.isEmpty
    }
    
    private var hasCustomAnimations: Bool {
        return !customAnimations.isEmpty
    }
    
    private var contexts: [AnimatingContext] {
        var contexts: [AnimatingContext] = []
        var context = first
        while let current = context {
            contexts.append(current)
            context = current.next
        }
        return contexts
    }
    
    private var first: AnimatingContext? {
        var context: AnimatingContext? = self
        while let current = context {
            if current.prev == nil {
                break
            }
            context = current.prev
        }
        return context
    }
    
    init(_ animations: [AnimatingType],
         target: UIView,
         options: [AnimatingOption],
         completion: (() -> ())? = nil) {
        super.init()
        
        self.animations = animations
        self.target = target
        options.forEach { option in
            switch option {
            case .curve(let curve): self.curve = curve
            case .damping(let damping): self.damping = damping
            case .delay(let delay): self.delay = delay
            case .duration(let duration): self.duration = duration
            case .repeatCount(let repeatCount): self.repeatCount = repeatCount
            case .autoreverse(let autoreverse): self.autoreverse = autoreverse
            case .velocity(let velocity): self.velocity = velocity
            }
        }
        self.completion = completion
    }
    
    func commit() {
        target?.isUserInteractionEnabled = false
        first?.animate()
    }
    
    private func unwind() {
        guard let target = target else { return }
        
        completion?()
        next?.animate()
        if self.next == nil {
            target.transform = .identity
            target.layer.transform = CATransform3DIdentity
            target.isUserInteractionEnabled = true
        }
    }
    
    private func animate() {
        animations.forEach { animation in
           animation.apply(self, position: .start)
        }
        
        applyViewAnimations()
        applyLayerAnimations()
        applyCustomAnimations()
    }
    
    private func applyTransforms() {
        guard let target = target else { return }
        
        if let alpha = alpha {
            target.alpha = alpha
        }
        let translate = target.transform.translatedBy(x: translation.x, y: translation.y)
        let translateAndScale = translate.scaledBy(x: self.scale.x, y: self.scale.y)
        let rotate = CGAffineTransform(rotationAngle: rotation)
        target.transform = rotate.concatenating(translateAndScale)
    }
    
    private func applyViewAnimations() {
        guard hasViewAnimations else { return }
        
        applyTransforms()
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       options: options,
                       animations: {
                           self.animations.forEach { animation in
                              animation.apply(self, position: .end)
                           }
                           self.applyTransforms()
                       },
                       completion: { _ in
                           self.unwind()
                       })
    }
    
    private func applyLayerAnimations() {
        guard let target = target, hasLayerAnimations else { return }
        
        let group = CAAnimationGroup()
        group.animations = layerAnimations
        group.duration = duration
        group.timingFunction = curve.asTimingFunction()
        group.repeatCount = repeatCount
        group.autoreverses = autoreverse
        group.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        group.delegate = self
        
        target.layer.add(group, forKey: "group")
    }
    
    private func applyCustomAnimations() {
        guard hasCustomAnimations else { return }
        
        customAnimations.forEach { animation in
            animation {
                self.unwind()
            }
        }
    }
    
}

extension AnimatingContext: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        unwind()
    }
    
}

extension AnimatingContext: Animating {
    
    private func add(_ animations: [AnimatingType], _ options: [AnimatingOption], _ completion: (() -> ())?) -> AnimatingContext {
        guard let target = target else { fatalError() }
        next = AnimatingContext(animations, target: target, options: options, completion: completion)
        next?.prev = self
        return next!
    }
    
    @discardableResult func animate(animations: [AnimatingType], options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add(animations, options, completion)
    }
    
    @discardableResult func translate(x: CGFloat, y: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.translate(x, y)], options, completion)
    }
    
    @discardableResult func scale(x: CGFloat, y: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.scale(x, y)], options, completion)
    }
    
    @discardableResult func rotate(angle: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.rotate(angle)], options, completion)
    }
    
    @discardableResult func backgroundColor(_ color: UIColor, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.backgroundColor(color)], options, completion)
    }
    
    @discardableResult func alpha(_ alpha: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.alpha(alpha)], options, completion)
    }
    
    @discardableResult func frame(_ frame: CGRect, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.frame(frame)], options, completion)
    }
    
    @discardableResult func bounds(_ bounds: CGRect, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.bounds(bounds)], options, completion)
    }
    
    @discardableResult func center(_ center: CGPoint, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.center(center)], options, completion)
    }
    
    @discardableResult func fadeIn(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.fadeIn(direction)], options, completion)
    }
    
    @discardableResult func fadeOut(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.fadeOut(direction)], options, completion)
    }
    
    @discardableResult func slide(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.slide(direction)], options, completion)
    }
    
    @discardableResult func squeeze(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.squeeze(direction)], options, completion)
    }
    
    @discardableResult func zoomIn(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.zoomIn], options, completion)
    }
    
    @discardableResult func zoomOut(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.zoomOut], options, completion)
    }
    
    @discardableResult func fall(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.fall], options, completion)
    }
    
    @discardableResult func shake(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.shake], options, completion)
    }
    
    @discardableResult func pop(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.pop], options, completion)
    }
    
    @discardableResult func flip(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.flip(direction)], options, completion)
    }
    
    @discardableResult func morph(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.morph], options, completion)
    }
    
    @discardableResult func flash(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.flash], options, completion)
    }
    
    @discardableResult func wobble(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.wobble], options, completion)
    }
    
    @discardableResult func swing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.swing], options, completion)
    }
    
    @discardableResult func boing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.boing], options, completion)
    }
    
    @discardableResult func delay(time: TimeInterval, completion: (() -> ())? = nil) -> AnimatingContext {
        add([.delay(time)], [], completion)
    }
    
}
