//
//  AnimatingRegistry.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

class AnimatingRegistry {
    
    static let shared: AnimatingRegistry = AnimatingRegistry()
    
    private var animations: [UUID: AnimatingContext] = [:]
    
    private init() {}
    
    func add(_ animation: AnimatingContext) {
        let uuid = UUID()
        animation.registrationID = uuid
        animations[uuid] = animation
        animation.target?.isUserInteractionEnabled = false
        animation.preprocess()
        animation.animate()
    }
    
    func remove(_ animation: AnimatingContext) {
        guard let uuid = animation.registrationID else { return }
        animations[uuid] = nil
    }
    
}
