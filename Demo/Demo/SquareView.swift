//
//  SquareView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

class SquareView: UIView {

    init() {
        super.init(frame: .zero)
        
        backgroundColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
