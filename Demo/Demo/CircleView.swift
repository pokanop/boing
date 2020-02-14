//
//  CircleView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct CircleView: View {
    
    var body: some View {
        let spectrum = Gradient(colors: [
            .red, .yellow, .green, .blue, .purple, .red
        ])
               
        let conic = AngularGradient(gradient: spectrum, center: .center, angle:
            .degrees(-90))
        
        return Circle()
            .fill(conic)
            .padding(40)
    }
    
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
