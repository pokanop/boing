//
//  AnimatingAxis.swift
//  Boing
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

/// The axis to use in `AnimatingType` values.
public enum AnimatingAxis: String, CaseIterable {
    
    case horizontal
    case vertical
    
}

extension AnimatingAxis: Nameable {
    
    /// The name of the axis.
    public var name: String {
        rawValue
    }
    
}
