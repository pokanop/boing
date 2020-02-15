//
//  ColorView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct ColorView: View {
    
    var color: Color = .blue
    var lineWidth: CGFloat = 2
    @State var scale: CGFloat = 0
    @Binding var isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .padding(8)
                .scaleEffect(scale)
            if isSelected {
                Circle()
                    .stroke(color, lineWidth: lineWidth)
                    .padding(4)
                    .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation {
                self.scale = 1
            }
        }
        .onTapGesture {
            withAnimation {
                self.isSelected.toggle()
            }
        }
    }
    
}

struct ColorView_Previews: PreviewProvider {
    @State static var isSelected: Bool = true
    
    static var previews: some View {
        ColorView(isSelected: ColorView_Previews.$isSelected)
    }
}
