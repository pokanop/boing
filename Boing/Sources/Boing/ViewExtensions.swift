//
//  ViewExtensions.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

extension UIView: Animating {
    
    func concatenate(transform: CGAffineTransform) {
        self.transform = self.transform.concatenating(transform)
    }
    
    @discardableResult public func animate(animations: [AnimatingType], options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext(animations, target: self, options: options, completion: completion)
    }
    
    @discardableResult public func translate(x: CGFloat, y: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.translate(x, y)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func scale(x: CGFloat, y: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.scale(x, y)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func rotate(angle: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.rotate(angle)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func backgroundColor(_ color: UIColor, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.backgroundColor(color)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func alpha(_ alpha: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.alpha(alpha)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func frame(_ frame: CGRect, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.frame(frame)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func bounds(_ bounds: CGRect, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.bounds(bounds)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func center(_ center: CGPoint, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.center(center)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func fadeIn(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.fadeIn(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func fadeOut(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.fadeOut(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func slide(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.slide(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func squeeze(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.squeeze(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func zoomIn(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.zoomIn], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func zoomOut(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.zoomOut], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func fall(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.fall], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func shake(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.shake], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func pop(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.pop], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func flip(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.flip(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func morph(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.morph], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func flash(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.flash], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func wobble(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.wobble], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func swing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.swing], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func boing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.boing], target: self, options: options, completion: completion)
    }
    
    @discardableResult public func delay(time: TimeInterval, completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.delay(time)], target: self, options: [], completion: completion)
    }
    
}
