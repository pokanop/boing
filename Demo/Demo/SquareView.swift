//
//  SquareView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

class SquareView: UIView {

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        backgroundColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
