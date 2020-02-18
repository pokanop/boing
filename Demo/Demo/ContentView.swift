//
//  ContentView.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

struct ContentView: View {
    
    @ObservedObject var store: AnimationsStore
    @State var useUIView: Bool = true
    @State private var needsRefresh: Bool = false
    @State private var isAnimating: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if useUIView {
                    HostView(isAnimating: self.$isAnimating, store: self.store)
                } else {
                    CircleView()
                }
                
                Form {
                    Section(header: Text("Options")) {
                        Toggle(isOn: $useUIView) {
                            Text("Use UIView")
                        }
                    }
                    
                    Section(header: Text("Animations")) {
                        ForEach(store.animations) { context in
                            if self.needsRefresh || !self.needsRefresh {    // HACK: WTF SwiftUI
                                NavigationLink(destination: AnimationDetail(context: context)) {
                                    Text(context.title)
                                        .foregroundColor(context.isEmpty ? .red : .black)
                                }
                            }
                        }
                        .onDelete(perform: delete)
                        
                        Button(action: add) {
                            Text("Add")
                        }
                    }
                    .onAppear {
                        self.needsRefresh.toggle()
                    }
                    
                    Section(header: Text("Actions")) {
                        Button(action: animate) {
                            Text("Animate")
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .modifier(KeyboardAdapter())
            }
            .navigationBarTitle("The Boing Demo")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func add() {
        store.addAnimation()
    }
    
    private func delete(at offsets: IndexSet) {
        store.removeAnimations(at: offsets)
    }
    
    private func animate() {
        isAnimating = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: AnimationsStore())
    }
}
