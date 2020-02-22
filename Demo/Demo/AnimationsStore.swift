//
//  AnimationsStore.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Combine

class AnimationsStore: ObservableObject {
    
    @Published var animations: [AnimationContext] = []
    var defaultAnimation: AnimationType?
    
    func addAnimation() {
        animations.append(AnimationContext())
    }
    
    func removeAnimations(at offsets: IndexSet) {
        animations.remove(atOffsets: offsets)
    }
    
}
