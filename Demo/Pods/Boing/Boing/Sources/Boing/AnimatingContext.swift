//
//  File.swift
//  
//
//  Created by Sahel Jalal on 2/10/20.
//

import UIKit

public class AnimatingContext: NSObject {
    
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
    
    public func commit() {
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
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
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
    
    @discardableResult public func animate(animations: [AnimatingType], options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add(animations, options, completion)
    }
    
    @discardableResult public func translate(x: CGFloat, y: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.translate(x, y)], options, completion)
    }
    
    @discardableResult public func scale(x: CGFloat, y: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.scale(x, y)], options, completion)
    }
    
    @discardableResult public func rotate(angle: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.rotate(angle)], options, completion)
    }
    
    @discardableResult public func backgroundColor(_ color: UIColor, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.backgroundColor(color)], options, completion)
    }
    
    @discardableResult public func alpha(_ alpha: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.alpha(alpha)], options, completion)
    }
    
    @discardableResult public func frame(_ frame: CGRect, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.frame(frame)], options, completion)
    }
    
    @discardableResult public func bounds(_ bounds: CGRect, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.bounds(bounds)], options, completion)
    }
    
    @discardableResult public func center(_ center: CGPoint, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.center(center)], options, completion)
    }
    
    @discardableResult public func fadeIn(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.fadeIn(direction)], options, completion)
    }
    
    @discardableResult public func fadeOut(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.fadeOut(direction)], options, completion)
    }
    
    @discardableResult public func slide(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.slide(direction)], options, completion)
    }
    
    @discardableResult public func squeeze(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.squeeze(direction)], options, completion)
    }
    
    @discardableResult public func zoomIn(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.zoomIn], options, completion)
    }
    
    @discardableResult public func zoomOut(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.zoomOut], options, completion)
    }
    
    @discardableResult public func fall(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.fall], options, completion)
    }
    
    @discardableResult public func shake(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.shake], options, completion)
    }
    
    @discardableResult public func pop(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.pop], options, completion)
    }
    
    @discardableResult public func flip(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.flip(direction)], options, completion)
    }
    
    @discardableResult public func morph(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.morph], options, completion)
    }
    
    @discardableResult public func flash(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.flash], options, completion)
    }
    
    @discardableResult public func wobble(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.wobble], options, completion)
    }
    
    @discardableResult public func swing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.swing], options, completion)
    }
    
    @discardableResult public func boing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.boing], options, completion)
    }
    
    @discardableResult public func delay(time: TimeInterval, completion: (() -> ())? = nil) -> AnimatingContext {
        add([.delay(time)], [], completion)
    }
    
}