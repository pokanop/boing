//
//  AnimatingContext.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

/// An `AnimatingContext` is a context used for executing one or more
/// animations.
///
/// It is the main object used to start an animation through implicitly when
/// no references remain. The context can be safely ignored in the middle of
/// sequences and provides a buidler pattern to add more animations.
///
/// Do not explicitly create an `AnimatingContext` and keeping a strong
/// reference will prevent the animation from starting. An `AnimatingContext`
/// is usually generated as a side effect of calling `Animating` methods
/// to perform animations.
public class AnimatingContext: NSObject {
    
    var animations: [AnimatingType] = []
    var completion: (() -> ())?
    var layerAnimations: [CAAnimation] = []
    var customAnimations: [((() -> ())?) -> ()] = []
    weak var target: UIView?
    private let group: DispatchGroup = DispatchGroup()
    private var breadcrumbs: [() -> ()] = []
    
    var options: [AnimatingOption] {
        return [
            .delay(delay),
            .duration(duration),
            .curve(curve),
            .damping(damping),
            .velocity(velocity),
            .repeatCount(repeatCount),
            .autoreverse(autoreverse),
            .removeOnCompletion(removeOnCompletion),
            .noAnimate(noAnimate)
        ]
    }
    
    var delay: TimeInterval = 0.0
    var duration: TimeInterval = 0.7
    var curve: AnimatingCurve = .easeInOut
    var damping: CGFloat = 0.7
    var velocity: CGFloat = 0.7
    var repeatCount: Float = 1.0
    var autoreverse: Bool = false
    var removeOnCompletion: Bool = false
    var noAnimate: Bool = false
    
    var translation: CGPoint?
    var scale: CGPoint?
    var rotation: CGFloat?
    var alpha: CGFloat?
    
    var registrationID: UUID? {
        didSet {
            next?.registrationID = registrationID
        }
    }
    
    var animationOptions: UIView.AnimationOptions {
        var options: UIView.AnimationOptions = [.beginFromCurrentState, curve.asOptions()]
        if autoreverse {
            options.insert(.autoreverse)
        }
        if repeatCount == .greatestFiniteMagnitude {
            options.insert(.repeat)
        }
        return options
    }
    
    private weak var prev: AnimatingContext? {
        didSet {
            guard prev != nil else { return }
            isTrailing = true   // Used to prevent duplicate registration
        }
    }
    private var next: AnimatingContext?
    
    private var isCopy: Bool = false
    private var isTrailing: Bool = false
    
    private var hasViewAnimations: Bool {
        return animations.filter({ $0.isViewAnimation }).count > 0
    }
    
    private var hasLayerAnimations: Bool {
        return animations.filter({ $0.isLayerAnimation }).count > 0
    }
    
    private var hasCustomAnimations: Bool {
        return animations.filter({ $0.isCustomAnimation }).count > 0
    }
    
    init(_ animations: [AnimatingType],
         target: UIView,
         options: [AnimatingOption],
         completion: (() -> ())? = nil) {
        super.init()
        
        self.animations = animations
        self.target = target
        self.set(options: options)
        self.completion = completion
    }
    
    /// The deinit method on `AnimatingContext` is used to execute underlying
    /// animations.
    ///
    /// It registers a copy of the animation that is retained until it completes.
    /// This allows for callers to build animation sequences using the simple and
    /// declarative API without needing to call something additional.
    deinit {
        guard !isCopy, !isTrailing else { return }
        
        AnimatingRegistry.shared.add(copy() as! AnimatingContext)
    }
    
    func set(options: [AnimatingOption]) {
        options.forEach { option in
            switch option {
            case .curve(let curve): self.curve = curve
            case .damping(let damping): self.damping = damping
            case .delay(let delay): self.delay = delay
            case .duration(let duration): self.duration = duration
            case .repeatCount(let repeatCount): self.repeatCount = repeatCount
            case .autoreverse(let autoreverse): self.autoreverse = autoreverse
            case .velocity(let velocity): self.velocity = velocity
            case .removeOnCompletion(let remove): self.removeOnCompletion = remove
            case .noAnimate(let noAnimate): self.noAnimate = noAnimate
            }
        }
    }
    
    public override func copy() -> Any {
        guard let target = target else { fatalError() }
        
        let copy = AnimatingContext(animations,
                                    target: target,
                                    options: options,
                                    completion: completion)
        copy.prev = prev
        copy.next = next
        copy.next?.prev = copy  // On deinit this appears to be set to nil
        copy.isCopy = true  // Used to prevent redundant animation registration
        
        return copy
    }
    
    private func wait() {
        // Ensure a single unwind is executed no matter how many animations
        // are executed
        DispatchQueue.global().async {
            self.group.wait()
            DispatchQueue.main.async {
                self.unwind()
            }
        }
    }
    
    private func unwind() {
        guard let target = target else { return }
        
        breadcrumbs.forEach { $0() }
        completion?()
        next?.animate()
        
        // Last animation
        guard self.next == nil else { return }
        
        if removeOnCompletion {
            target.transform = .identity
            target.layer.transform = CATransform3DIdentity
        }
        target.isUserInteractionEnabled = true
        
        AnimatingRegistry.shared.remove(self)
    }
    
    func preprocess() {
        // Mark any `noAnimate` contexts before starting the animations
        walk { ctx in
            guard ctx.animations.contains(.now) else { return }
            
            ctx.walk(reverse: true) { ctx in
                ctx.set(options: [.noAnimate(true)])
            }
        }
    }
    
    func animate() {
        applyViewAnimations()
        applyLayerAnimations()
        applyCustomAnimations()
        
        wait()
    }
    
    func animate(duration: TimeInterval? = nil,
                 delay: TimeInterval? = nil,
                 damping: CGFloat? = nil,
                 velocity: CGFloat? = nil,
                 options: UIView.AnimationOptions? = nil,
                 animations: @escaping () -> (),
                 completion: (() -> ())? = nil) {
        UIView.animate(withDuration: duration ?? self.duration,
                       delay: delay ?? self.delay,
                       usingSpringWithDamping: damping ?? self.damping,
                       initialSpringVelocity: velocity ?? self.velocity,
                       options: options ?? self.animationOptions,
                       animations: {
            // DEPRECATED: Poo. Need to find a different solution after iOS 13
            // See https://developer.apple.com/documentation/uikit/uiview/1622419-setanimationrepeatcount
            UIView.setAnimationRepeatCount(self.repeatCount)
            animations()
        }) { _ in
            completion?()
        }
    }
    
    private func applyTransforms() {
        guard let target = target else { return }
        
        if let alpha = alpha {
            target.alpha = alpha
        }
        
        var transform = target.transform
        if let translation = translation {
            transform = transform.translatedBy(x: translation.x, y: translation.y)
        }
        
        if let scale = scale {
            transform = transform.scaledBy(x: scale.x, y: scale.y)
        }
        
        if let rotation = rotation {
            let rotate = CGAffineTransform(rotationAngle: rotation * .pi / 180)
            transform = rotate.concatenating(transform)
        }
        
        if transform != target.transform {
            target.transform = transform
        }
    }
    
    private func applyViewAnimations() {
        guard hasViewAnimations else { return }
        
        group.enter()
        
        animations.forEach { $0.applyViewUpdates(for: self, position: .start) }
        applyTransforms()
        
        let applyClosure = {
            self.animations.forEach { $0.applyViewUpdates(for: self, position: .end) }
            self.applyTransforms()
        }
        
        guard !noAnimate else {
            applyClosure()
            group.leave()
            return
        }
        
        animate(animations: {
            applyClosure()
        }) {
            self.group.leave()
        }
    }
    
    private func applyLayerAnimations() {
        guard let target = target, hasLayerAnimations else { return }
        
        group.enter()
        
        animations.forEach { $0.applyLayerUpdates(for: self) }
        
        guard !noAnimate else {
            group.leave()
            return
        }
        
        let group = CAAnimationGroup()
        group.animations = layerAnimations
        group.duration = duration
        group.timingFunction = curve.asTimingFunction()
        group.repeatCount = repeatCount
        group.autoreverses = autoreverse
        group.fillMode = .forwards
        group.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
        group.delegate = self
        
        target.layer.add(group, forKey: "group")
    }
    
    private func applyCustomAnimations() {
        guard hasCustomAnimations else { return }
        
        group.enter()
        
        animations.forEach { $0.applyCustomUpdates(for: self) }
        
        customAnimations.forEach { animation in
            self.group.enter()
            animation {
                self.group.leave()
            }
        }
        
        group.leave()
    }
    
    func persist(breadcrumb: @escaping () -> ()) {
        guard !removeOnCompletion else { return }
        breadcrumbs.append(breadcrumb)
    }
    
    func reset(breadcrumb: @escaping () -> ()) {
        guard removeOnCompletion else { return }
        breadcrumbs.append(breadcrumb)
    }
    
    func walk(reverse: Bool = false, visitor: (AnimatingContext) -> ()) {
        var ctx: AnimatingContext? = self
        while ctx != nil {
            guard let c = ctx else { break }
            visitor(c)
            ctx = reverse ? c.prev : c.next
        }
    }
    
}

extension AnimatingContext: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        group.leave()
    }
    
}

extension AnimatingContext: Animating {
    
    private func add(_ animations: [AnimatingType], _ options: [AnimatingOption], _ completion: (() -> ())?) -> AnimatingContext {
        guard let target = target else { fatalError() }
        let next = AnimatingContext(animations, target: target, options: options, completion: completion)
        self.next = next
        next.prev = self
        return next
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
    
    @discardableResult public func rotate(_ angle: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.rotate(angle)], options, completion)
    }
    
    @discardableResult public func anchorPoint(_ point: CGPoint, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.anchorPoint(point)], options, completion)
    }
    
    @discardableResult public func backgroundColor(_ color: UIColor, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.backgroundColor(color)], options, completion)
    }
    
    @discardableResult public func cornerRadius(_ cornerRadius: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.cornerRadius(cornerRadius)], options, completion)
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
    
    @discardableResult public func size(_ size: CGSize, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.size(size)], options, completion)
    }
    
    @discardableResult public func borderColor(_ color: UIColor, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.borderColor(color)], options, completion)
    }
    
    @discardableResult public func borderWidth(_ width: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.borderWidth(width)], options, completion)
    }
    
    @discardableResult public func shadowColor(_ color: UIColor, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.shadowColor(color)], options, completion)
    }
    
    @discardableResult public func shadowOffset(_ offset: CGSize, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.shadowOffset(offset)], options, completion)
    }
    
    @discardableResult public func shadowOpacity(_ opacity: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.shadowOpacity(opacity)], options, completion)
    }
    
    @discardableResult public func shadowRadius(_ radius: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.shadowRadius(radius)], options, completion)
    }
    
    @discardableResult public func transform(_ transform: CGAffineTransform, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.transform(transform)], options, completion)
    }
    
    @discardableResult public func layerTransform(_ transform: CATransform3D, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext {
        add([.layerTransform(transform)], options, completion)
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
    
    @discardableResult public func flash(options: [AnimatingOption] = [.duration(0.5)], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.flash], options, completion)
    }
    
    @discardableResult public func wobble(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.wobble], options, completion)
    }
    
    @discardableResult public func swing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.swing], options, completion)
    }
    
    @discardableResult public func boing(options: [AnimatingOption] = [.damping(0.2), .velocity(5)], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.boing], options, completion)
    }
    
    @discardableResult public func bounce(options: [AnimatingOption] = [.duration(1.5)], completion: (() -> ())? = nil) -> AnimatingContext {
        add([.bounce], options, completion)
    }
    
    @discardableResult public func delay(time: TimeInterval = 0.7, completion: (() -> ())? = nil) -> AnimatingContext {
        add([.delay(time)], [], completion)
    }
    
    @discardableResult public func identity(time: TimeInterval = 0.7, completion: (() -> ())? = nil) -> AnimatingContext {
        add([.identity(time)], [], completion)
    }
    
    @discardableResult public func now(completion: (() -> ())? = nil) -> AnimatingContext {
        add([.now], [], completion)
    }
    
}
