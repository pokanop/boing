//
//  AnimatingAxis.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

public enum AnimatingAxis: String, CaseIterable {
    
    case horizontal
    case vertical
    
}

extension AnimatingAxis: Nameable {
    
    public var name: String {
        rawValue
    }
    
}
