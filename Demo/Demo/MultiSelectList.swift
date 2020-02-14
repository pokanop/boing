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
            ForEach(self.items, id: \.self) { item -> MultiSelectListRow in
                let binding = Binding(
                    get: { self.selections.contains(item) },
                    set: { $0 ? self.selections.append(item) : self.selections.removeAll(where: { $0 == item }) }
                )
                return MultiSelectListRow(title: item.name, isSelected: binding)
            }
        }
        .navigationBarTitle("Animation Types", displayMode: .inline)
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

extension AnimationType: Selectable {}
