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
    
    func makeUIView(context: UIViewRepresentableContext<HostView>) -> SquareView {
        return SquareView()
    }
    
    func updateUIView(_ uiView: SquareView, context: UIViewRepresentableContext<HostView>) {
        if isAnimating {
            let completion = { (animation: AnimationContext) in
                if animation == self.store.animations.last! {
                    self.isAnimating = false
                }
            }
            
            var ctx: AnimatingContext?
            self.store.animations.filter { $0.enabled }.forEach { animation in
                if ctx == nil {
                    ctx = uiView.animate(animations: animation.animatingTypes, options: animation.animatingOptions, completion: { completion(animation) })
                } else {
                    ctx = ctx?.animate(
                        animations: animation.animatingTypes,
                        options: animation.animatingOptions,
                        completion: { completion(animation) }
                    )
                }
            }
            ctx?.commit()
        }
    }
    
}