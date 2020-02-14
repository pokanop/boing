//
//  AnimationProperties.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct AnimationProperties: View {
    
    @Binding var animation: AnimationType
    
    var body: some View {
        Text(animation.name)
    }
}

struct AnimationProperties_Previews: PreviewProvider {
    @State static var animation: AnimationType = AnimationType()
    
    static var previews: some View {
        AnimationProperties(animation: AnimationProperties_Previews.$animation)
    }
}
