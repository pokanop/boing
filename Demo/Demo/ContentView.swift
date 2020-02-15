//
//  ContentView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

struct ContentView: View {
    
    @ObservedObject var animationsStore: AnimationsStore
    @State var useUIView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                CircleView()
                
                Form {
                    Section(header: Text("Options")) {
                        Toggle(isOn: $useUIView) {
                            Text("Use UIView")
                        }
                    }
                    
                    Section(header: Text("Animations")) {
                        ForEach(animationsStore.animations.indexed(), id: \.1.id) { index, context in
                            NavigationLink(destination: AnimationDetail(context: self.$animationsStore.animations[index])) {
                                Text(context.title)
                                    .foregroundColor(context.isEmpty ? .red : .black)
                            }
                        }
                        .onDelete(perform: delete)
                        Button(action: add) {
                            Text("Add")
                        }
                    }
                    
                    Section(header: Text("Actions")) {
                        Button(action: animate) {
                            Text("Animate")
                        }
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle("The Boing Demo")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func add() {
        animationsStore.addAnimation()
    }
    
    private func delete(at offsets: IndexSet) {
        animationsStore.removeAnimations(at: offsets)
    }
    
    private func animate() {
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(animationsStore: AnimationsStore())
    }
}
