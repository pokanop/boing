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
    @State private var needsRefresh: Bool = false
    
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
                        ForEach(animationsStore.animations) { context in
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
