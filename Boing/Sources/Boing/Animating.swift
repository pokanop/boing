//
//  Animating.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit
import QuartzCore

/// Animating protocol for providing rich animation methods to the user interface.
///
/// Provides convenience API to trigger animations including basic animation types
/// like `scale` or `translate` and presets that do more interesting things like
/// `morph` or `boing`. The interface also provides facilities for composing
/// several animations together.
///
/// All methods return an `AnimatingContext` which can be used to build and
/// sequence more animations easily. A complete example may look like:
///
///     view
///         .scale(x: 1.2, y: 1.2)
///         .flip(direction: .left)
///         .boing()
///
/// Both `UIView` and `AnimatingContext` are extended to conform to this protocol.
public protocol Animating {
    
    /// Core animate method that can be used to combine one or many animations together.
    ///
    /// The `animate` method builds a single `AnimatingContext` that allows options to
    /// be configured for the `AnimatingType` values that were provided. These options include
    /// properties like `duration` or `delay` which apply on the set of animations in this context.
    ///
    /// - Parameters:
    ///   - animations: A list of `AnimatingType` that will be executed together.
    ///   - options: The options to apply to the set of animations in this call.
    ///   - completion: A completion handler to be exected after animations are finished.
    @discardableResult func animate(animations: [AnimatingType], options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    // MARK: - Basic animations
    
    /// Translate content by `x` and `y` in an animation.
    ///
    /// - Parameters:
    ///   - x: The translation value on the x axis.
    ///   - y: The translation value on the y axis.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func translate(x: CGFloat, y: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Scale content by `x` and `y` in an animation.
    ///
    /// - Parameters:
    ///   - x: The scale value on the x axis.
    ///   - y: The scale value on the y axis.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func scale(x: CGFloat, y: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Rotate content by an `angle` in an animation.
    ///
    /// - Parameters:
    ///   - angle: The angle in degrees for the rotation.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func rotate(angle: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the background color of content in an animation.
    ///
    /// - Parameters:
    ///   - color: The desired background color of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func backgroundColor(_ color: UIColor, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the corner radius of content in an animation.
    ///
    /// - Parameters:
    ///   - radius: The desired corner radius of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func cornerRadius(_ cornerRadius: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the alpha of content in an animation.
    ///
    /// - Parameters:
    ///   - radius: The desired alpha of the content.
    ///   - options: The options to apply to this translation animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func alpha(_ alpha: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the frame of content in an animation.
    ///
    /// - Parameters:
    ///   - frame: The desired frame of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func frame(_ frame: CGRect, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the bounds of content in an animation.
    ///
    /// - Parameters:
    ///   - bounds: The desired bounds of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func bounds(_ bounds: CGRect, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the center of content in an animation.
    ///
    /// - Parameters:
    ///   - center: The desired center of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func center(_ center: CGPoint, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the size of content in an animation.
    ///
    /// - Parameters:
    ///   - size: The desired size of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func size(_ size: CGSize, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the border color of content in an animation.
    ///
    /// - Parameters:
    ///   - color: The desired border color of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func borderColor(_ color: UIColor, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the border width of content in an animation.
    ///
    /// - Parameters:
    ///   - width: The desired border width of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func borderWidth(_ width: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the shadow color of content in an animation.
    ///
    /// - Parameters:
    ///   - color: The desired shadow color of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func shadowColor(_ color: UIColor, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the shadow offset of content in an animation.
    ///
    /// - Parameters:
    ///   - offset: The desired shadow offset of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func shadowOffset(_ offset: CGSize, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the shadow opacity of content in an animation.
    ///
    /// - Parameters:
    ///   - opacity: The desired shadow opacity of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func shadowOpacity(_ opacity: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Modify the shadow radius of content in an animation.
    ///
    /// - Parameters:
    ///   - radius: The desired shadow radius of the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func shadowRadius(_ radius: CGFloat, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    // MARK: - Preset animations
    
    /// Perform a fade in animation for content from a given direction.
    ///
    /// - Parameters:
    ///   - direction: The `AnimatingDirection` to fade in the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func fadeIn(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a fade out animation for content from a given direction.
    ///
    /// - Parameters:
    ///   - direction: The `AnimatingDirection` to fade out the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func fadeOut(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a slide animation for content from a given direction.
    ///
    /// - Parameters:
    ///   - direction: The `AnimatingDirection` to slide the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func slide(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a squeeze animation for content from a given direction.
    ///
    /// - Parameters:
    ///   - direction: The `AnimatingDirection` to squeeze the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func squeeze(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a zoom in animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func zoomIn(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a zoom out animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func zoomOut(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a fall animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func fall(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a shake animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func shake(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a pop animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func pop(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a flip animation for content in a given direction.
    ///
    /// - Parameters:
    ///   - direction: The `AnimatingDirection` to flip the content.
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func flip(direction: AnimatingDirection, options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a morph animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func morph(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a flash animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func flash(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a wobble animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func wobble(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a swing animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func swing(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    /// Perform a boing animation for content.
    ///
    /// - Parameters:
    ///   - options: The options to apply to this animation.
    ///   - completion: A completion handler to be exected after the animation is finished.
    @discardableResult func boing(options: [AnimatingOption], completion: (() -> ())?) -> AnimatingContext
    
    // MARK: - Utilities
    
    /// Perform a delay in an animation sequence.
    ///
    /// This method is a helper meant to be used between animations if needed.
    ///
    /// - Parameters:
    ///   - time: The time to delay before the next sequence.
    ///   - completion: A completion handler to be exected after the delay is finished.
    @discardableResult func delay(time: TimeInterval, completion: (() -> ())?) -> AnimatingContext
    
    /// Perform an animation back to identity.
    ///
    /// This method is used to reset state to identity transforms with animation.
    ///
    /// - Parameters:
    ///   - time: The time to delay before the next sequence.
    ///   - completion: A completion handler to be exected after the delay is finished.
    @discardableResult func identity(time: TimeInterval, completion: (() -> ())?) -> AnimatingContext
    
}
