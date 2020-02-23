//
//  SquareContainerView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import UIKit

class SquareContainerView: UIView {
    
    let squareView: SquareView = SquareView()
    var isCentered: Bool = false

    init() {
        super.init(frame: .zero)
        
        addSubview(squareView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !isCentered else { return }
        
        squareView.center = center
        isCentered = true
    }
    
}
