//
//  MultiSelectListRow.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct MultiSelectListRow: View {
    
    var title: String
    var isSelected: Bool
    var action: () -> ()

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    
}

struct MultiSelectListRow_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectListRow(title: "Title", isSelected: false, action: {})
    }
}
