//
//  HostView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

struct HostView: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    @ObservedObject var store: AnimationsStore
    
    func makeUIView(context: UIViewRepresentableContext<HostView>) -> SquareContainerView {
        return SquareContainerView()
    }
    
    func updateUIView(_ uiView: SquareContainerView, context: UIViewRepresentableContext<HostView>) {
        if isAnimating {
            if let animation = store.defaultAnimation {
                performDefaultAnimation(on: uiView.squareView, type: animation.type)
            } else {
                performAnimations(on: uiView)
            }
        }
    }
    
    func performDefaultAnimation(on uiView: SquareView, type: AnimatingType) {
        let options: [AnimatingOption] = [
            .removeOnCompletion(true)
        ]
        
        let completion = {
            uiView.alpha = 1.0
            uiView.layer.borderColor = UIColor.black.cgColor
            uiView.layer.borderWidth = 0
            uiView.layer.shadowRadius = 0
            uiView.layer.shadowOpacity = 0
            uiView.layer.shadowOffset = .zero
            uiView.layer.shadowColor = UIColor.black.cgColor
            self.isAnimating = false
            self.store.defaultAnimation = nil
        }
        
        switch type {
        case .translate: uiView.translate(x: 100, y: 100, options: options, completion: completion)
        case .scale: uiView.scale(x: 1.3, y: 1.3, options: options, completion: completion)
        case .rotate: uiView.rotate(angle: 90, options: options, completion: completion)
        case .backgroundColor: uiView.backgroundColor(.blue, options: options, completion: completion)
        case .cornerRadius: uiView.cornerRadius(100, options: options, completion: completion)
        case .alpha: uiView.alpha(0.5, options: options, completion: completion)
        case .frame: uiView.frame(uiView.frame.offsetBy(dx: 20, dy: -20).insetBy(dx: 40, dy: -10), options: options, completion: completion)
        case .bounds: uiView.bounds(uiView.bounds.insetBy(dx: -20, dy: -20), options: options, completion: completion)
        case .center: uiView.center(uiView.center.applying(CGAffineTransform(translationX: 20, y: 40)), options: options, completion: completion)
        case .size: uiView.size(CGSize(width: 30, height: 40), options: options, completion: completion)
        case .borderColor:
            uiView.layer.borderWidth = 10.0
            uiView.borderColor(.red, options: options, completion: completion)
        case .borderWidth:
            uiView.layer.borderColor = UIColor.red.cgColor
            uiView.borderWidth(10, options: options, completion: completion)
        case .shadowColor:
            uiView.layer.shadowColor = UIColor.blue.cgColor
            uiView.layer.shadowOpacity = 1.0
            uiView.layer.shadowRadius = 40.0
            uiView.shadowColor(.red, options: options + [.duration(1.2)], completion: completion)
        case .shadowOffset:
            uiView.layer.shadowColor = UIColor.red.cgColor
            uiView.layer.shadowOffset = CGSize(width: -20.0, height: -20.0)
            uiView.layer.shadowOpacity = 1.0
            uiView.layer.shadowRadius = 40.0
            uiView.shadowOffset(CGSize(width: 20.0, height: 20.0), options: options + [.duration(1.2)], completion: completion)
        case .shadowOpacity:
            uiView.layer.shadowColor = UIColor.red.cgColor
            uiView.layer.shadowOpacity = 0.0
            uiView.layer.shadowRadius = 40.0
            uiView.shadowOpacity(1.0, options: options + [.duration(1.2)], completion: completion)
        case .shadowRadius:
            uiView.layer.shadowColor = UIColor.red.cgColor
            uiView.layer.shadowOpacity = 1.0
            uiView.layer.shadowRadius = 1.0
            uiView.shadowRadius(100, options: options + [.duration(1.2)], completion: completion)
        case .fadeIn: uiView.fadeIn(options: options, completion: completion)
        case .fadeOut: uiView.fadeOut(options: options, completion: completion)
        case .slide: uiView.slide(direction: .left, options: options, completion: completion)
        case .squeeze: uiView.squeeze(direction: .down, options: options, completion: completion)
        case .zoomIn: uiView.zoomIn(options: options, completion: completion)
        case .zoomOut: uiView.zoomOut(options: options, completion: completion)
        case .fall: uiView.fall(options: options, completion: completion)
        case .shake: uiView.shake(options: options, completion: completion)
        case .pop: uiView.pop(options: options, completion: completion)
        case .flip: uiView.flip(direction: .right, options: options, completion: completion)
        case .morph: uiView.morph(options: options, completion: completion)
        case .flash: uiView.flash(options: options, completion: completion)
        case .wobble: uiView.wobble(options: options, completion: completion)
        case .swing: uiView.swing(options: options, completion: completion)
        case .boing: uiView.boing(options: options, completion: completion)
        case .delay: uiView.delay(time: 0, completion: completion)
        }
    }
    
    func performAnimations(on uiView: SquareContainerView) {
        let completion = { (animation: AnimationContext) in
            guard let last = self.store.animations.last else {
                self.isAnimating = false
                return
            }
            
            if animation == last {
                self.isAnimating = false
            }
        }
        
        var first: AnimatingContext?
        var ctx: AnimatingContext?
        self.store.animations.filter { $0.enabled }.forEach { animation in
            if ctx == nil {
                first = uiView.squareView.animate(animations: animation.animatingTypes, options: animation.animatingOptions, completion: { completion(animation) })
                ctx = first
            } else {
                ctx = ctx?.animate(
                    animations: animation.animatingTypes,
                    options: animation.animatingOptions,
                    completion: { completion(animation) }
                )
            }
        }
    }
    
}
