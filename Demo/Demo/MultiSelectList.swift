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
    @State var selections: [T] = []
    var selectAction: ([T]) -> ()

    var body: some View {
        List {
            ForEach(self.items, id: \.self) { item in
                MultiSelectListRow(title: item.name, isSelected: Binding(
                    get: { self.selections.contains(item) },
                    set: { selected in
                        self.selections.removeAll(where: { $0 == item })
                        if selected {
                            self.selections.append(item)
                        }
                        self.selectAction(self.selections)
                    }
                ))
            }
        }
        .navigationBarTitle("Animation Types", displayMode: .inline)
        .listStyle(PlainListStyle())
    }
    
}

struct MultiSelectList_Previews: PreviewProvider {
    static var previews: some View {
        return MultiSelectList(items: ["Hello", "World"], selectAction: { _ in })
    }
}

extension String: Selectable {
    var name: String { return self }
}

extension AnimationType: Selectable {}
