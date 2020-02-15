//
//  MultiSelectListRow.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct MultiSelectListRow: View {
    
    var title: String
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: toggle) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    
    private func toggle() {
        isSelected.toggle()
    }
    
}

struct MultiSelectListRow_Previews: PreviewProvider {
    @State static var isSelected: Bool = true
    
    static var previews: some View {
        MultiSelectListRow(title: "Title", isSelected: MultiSelectListRow_Previews.$isSelected)
    }
}
