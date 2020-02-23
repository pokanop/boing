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
    @State private var showPresets: Bool = false
    
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
                        Picker(selection: $showPresets, label: Text("Segments")) {
                            Text("Presets").tag(true)
                            Text("Custom").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if showPresets {
                            ForEach(0..<AnimationType.allCases.count) { idx in
                                PresetButton(animation: AnimationType.allCases[idx], isAnimating: self.$isAnimating, store: self.store)
                            }
                        } else {
                            ForEach(store.animations) { context in
                                if self.needsRefresh || !self.needsRefresh {    // HACK: WTF SwiftUI
                                    NavigationLink(destination: AnimationDetail(context: context)) {
                                        Text(context.title)
                                            .foregroundColor(context.isEmpty ? .red : .primary)
                                    }
                                }
                            }
                            .onDelete(perform: delete)
                            
                            Button(action: add) {
                                Text("Add")
                            }
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
        Group {
            ContentView(store: AnimationsStore())
                .environment(\.colorScheme, .light)
            ContentView(store: AnimationsStore())
                .environment(\.colorScheme, .dark)
        }
    }
}

struct PresetButton: View {
    
    @State var animation: AnimationType
    @Binding var isAnimating: Bool
    @ObservedObject var store: AnimationsStore
    
    var body: some View {
        Button(animation.name) {
            self.store.defaultAnimation = self.animation
            self.isAnimating = true
        }
    }
    
}
