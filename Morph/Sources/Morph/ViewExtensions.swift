//
//  ViewExtensions.swift
//  Morph
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

extension UIView: Animating {
    
    func concatenate(transform: CGAffineTransform) {
        self.transform = self.transform.concatenating(transform)
    }
    
    @discardableResult func animate(animations: [AnimatingType], options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext(animations, target: self, options: options, completion: completion)
    }
    
    @discardableResult func translate(x: CGFloat, y: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.translate(x, y)], target: self, options: options, completion: completion)
    }
    
    @discardableResult func scale(x: CGFloat, y: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.scale(x, y)], target: self, options: options, completion: completion)
    }
    
    @discardableResult func rotate(angle: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.rotate(angle)], target: self, options: options, completion: completion)
    }
    
    func backgroundColor(_ color: UIColor, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.backgroundColor(color)], target: self, options: options, completion: completion)
    }
    
    func alpha(_ alpha: CGFloat, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.alpha(alpha)], target: self, options: options, completion: completion)
    }
    
    func frame(_ frame: CGRect, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.frame(frame)], target: self, options: options, completion: completion)
    }
    
    func bounds(_ bounds: CGRect, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.bounds(bounds)], target: self, options: options, completion: completion)
    }
    
    func center(_ center: CGPoint, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.center(center)], target: self, options: options, completion: completion)
    }
    
    @discardableResult func fadeIn(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.fadeIn(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult func fadeOut(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.fadeOut(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult func slide(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.slide(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult func squeeze(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.squeeze(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult func zoomIn(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.zoomIn], target: self, options: options, completion: completion)
    }
    
    @discardableResult func zoomOut(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.zoomOut], target: self, options: options, completion: completion)
    }
    
    @discardableResult func fall(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.fall], target: self, options: options, completion: completion)
    }
    
    @discardableResult func shake(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.shake], target: self, options: options, completion: completion)
    }
    
    @discardableResult func pop(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.pop], target: self, options: options, completion: completion)
    }
    
    @discardableResult func flip(direction: AnimatingDirection = .none, options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.flip(direction)], target: self, options: options, completion: completion)
    }
    
    @discardableResult func morph(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.morph], target: self, options: options, completion: completion)
    }
    
    @discardableResult func flash(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.flash], target: self, options: options, completion: completion)
    }
    
    @discardableResult func wobble(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.wobble], target: self, options: options, completion: completion)
    }
    
    @discardableResult func swing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.swing], target: self, options: options, completion: completion)
    }
    
    @discardableResult func boing(options: [AnimatingOption] = [], completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.boing], target: self, options: options, completion: completion)
    }
    
    @discardableResult func delay(time: TimeInterval, completion: (() -> ())? = nil) -> AnimatingContext {
        return AnimatingContext([.delay(time)], target: self, options: [], completion: completion)
    }
    
}
