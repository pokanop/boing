//
//  ColorPicker.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct ColorPicker: View {
    
    @State var selections: [Color] = []
    var colors: [Color] = [.black, .blue, .gray, .green, .orange, .pink, .purple, .red, .white, .yellow]
    var multiselect: Bool = false
    var selectAction: ([Color]) -> ()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(colors, id: \.self) { color in
                    ColorView(color: color, isSelected: Binding(
                        get: { self.selections.contains(color) },
                        set: { selected in
                            if self.multiselect {
                                self.selections.removeAll(where: { $0 == color })
                            } else {
                                self.selections.removeAll()
                            }
                            
                            if selected {
                                self.selections.append(color)
                            }
                            self.selectAction(self.selections)
                        }
                    ))
                    .frame(width: 40, height: 40)
                }
            }
        }
    }
    
}

struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        ColorPicker(selectAction: { _ in })
    }
}
