//
//  PresetButton.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct PresetButton: View {
    
    @State var animation: AnimationType
    @Binding var isAnimating: Bool
    @ObservedObject var store: AnimationsStore
    
    var body: some View {
        CenteredButton(title: animation.name) {
            self.store.defaultAnimation = self.animation
            self.isAnimating = true
        }
    }
    
}

struct PresetButton_Previews: PreviewProvider {
    @State static var isAnimating: Bool = false
    
    static var previews: some View {
        PresetButton(animation: AnimationType(), isAnimating: PresetButton_Previews.$isAnimating, store: AnimationsStore())
    }
}
