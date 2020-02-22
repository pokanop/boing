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
        let completion = {
            self.isAnimating = false
            self.store.defaultAnimation = nil
        }
        
        switch type {
        case .translate: uiView.translate(x: 100, y: 100, completion: completion)
        case .scale: uiView.scale(x: 1.3, y: 1.3, completion: completion)
        case .rotate: uiView.rotate(angle: 90, completion: completion)
        case .backgroundColor: uiView.backgroundColor(.blue, completion: completion)
        case .cornerRadius: uiView.cornerRadius(20, completion: completion)
        case .alpha: uiView.alpha(0.5, completion: completion)
        case .frame: uiView.frame(uiView.frame.offsetBy(dx: 20, dy: -20).insetBy(dx: 40, dy: -10), completion: completion)
        case .bounds: uiView.bounds(uiView.bounds.insetBy(dx: -20, dy: -20), completion: completion)
        case .center: uiView.center(uiView.center.applying(CGAffineTransform(translationX: 20, y: 40)), completion: completion)
        case .size: uiView.size(CGSize(width: 30, height: 40), completion: completion)
        case .borderColor: uiView.borderColor(.blue, completion: completion)
        case .borderWidth: uiView.borderWidth(5, completion: completion)
        case .shadowColor: uiView.shadowColor(.blue, completion: completion)
        case .shadowOffset: uiView.shadowOffset(CGSize(width: 5, height: 5), completion: completion)
        case .shadowOpacity: uiView.shadowOpacity(5, completion: completion)
        case .shadowRadius: uiView.shadowRadius(5, completion: completion)
        case .fadeIn: uiView.fadeIn(completion: completion)
        case .fadeOut: uiView.fadeOut(completion: completion)
        case .slide: uiView.slide(direction: .left, completion: completion)
        case .squeeze: uiView.squeeze(direction: .down, completion: completion)
        case .zoomIn: uiView.zoomIn(completion: completion)
        case .zoomOut: uiView.zoomOut(completion: completion)
        case .fall: uiView.fall(completion: completion)
        case .shake: uiView.shake(completion: completion)
        case .pop: uiView.pop(completion: completion)
        case .flip: uiView.flip(direction: .right, completion: completion)
        case .morph: uiView.morph(completion: completion)
        case .flash: uiView.flash(completion: completion)
        case .wobble: uiView.wobble(completion: completion)
        case .swing: uiView.swing(completion: completion)
        case .boing: uiView.boing(completion: completion)
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
