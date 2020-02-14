//
//  Animation.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

class AnimationContext: ObservableObject, Identifiable {
    
    let id: UUID = UUID()
    @Published var animations: [AnimatingType] = []
    @Published var delay: TimeInterval = 0.0
    @Published var duration: TimeInterval = 0.7
    @Published var curve: AnimatingCurve = .easeInOut
    @Published var damping: CGFloat = 0.7
    @Published var velocity: CGFloat = 0.7
    @Published var repeatCount: Float = 1.0
    @Published var autoreverse: Bool = false
    
    var title: String {
        return animations.count > 0 ? animations.map { $0.name }.joined(separator: ", ") : "configure"
    }
    
    func addAnimation() {
        animations.append(.boing)
    }

}
