//
//  MultiSelectList.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

protocol Selectable: Hashable {
    var name: String { get }
}

struct MultiSelectList<T: Selectable>: View {
    
    var items: [T]
    @Binding var selections: [T]

    var body: some View {
        List {
            ForEach(self.items, id: \.self) { item in
                MultiSelectListRow(title: item.name, isSelected: self.selections.contains(item)) {
                    if self.selections.contains(item) {
                        self.selections.removeAll(where: { $0 == item })
                    }
                    else {
                        self.selections.append(item)
                    }
                }
            }
        }
    }
    
}

struct MultiSelectList_Previews: PreviewProvider {
    @State static var selections: [String] = []
    
    static var previews: some View {
        return MultiSelectList(items: ["Hello", "World"], selections: MultiSelectList_Previews.$selections)
    }
}

extension String: Selectable {
    var name: String { return self }
}

extension AnimatingType: Selectable {}
