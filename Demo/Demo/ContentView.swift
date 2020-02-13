//
//  ContentView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var useUIView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                CircleView()
                
                List {
                    Section {
                        Toggle(isOn: $useUIView) {
                            Text("Use UIView")
                        }
                    }
                    
                    Section {
                        Text("Animation")
                        Button(action: add) {
                            Text("Add")
                        }
                    }
                    
                    Section {
                        Button(action: animate) {
                            Text("Animate")
                        }
                    }
                }.listStyle(GroupedListStyle())
            }
            .navigationBarTitle("The Boing Demo")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func add() {
        
    }
    
    private func animate() {
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
