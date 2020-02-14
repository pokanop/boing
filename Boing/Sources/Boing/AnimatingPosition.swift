//
//  AnimatingPosition.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

enum AnimatingPosition: String, CaseIterable {
    
    case start
    case end
    
}

extension AnimatingPosition: Nameable {
    
    var name: String {
        rawValue
    }
    
}
