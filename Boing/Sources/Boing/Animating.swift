//
//  Animating.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit
import QuartzCore

public protocol Animating {
    
    @discardableResult func animate(animations: [AnimatingType], options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    // Basic animations
    @discardableResult func translate(x: CGFloat, y: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func scale(x: CGFloat, y: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func rotate(angle: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func backgroundColor(_ color: UIColor, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    @discardableResult func cornerRadius(_ cornerRadius: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
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
