//
//  AnimationDetail.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

struct AnimationDetail: View {
    
    @ObservedObject var context: AnimationContext
    
    var body: some View {
        Form {
            Toggle(isOn: $context.enabled) {
                Text("enabled")
            }
            
            Group {
                Section(header: Text("Types")) {
                    NavigationLink(destination: MultiSelectList(items: AnimationType.allCases, selections: context.animations) { selections in
                        self.context.animations = selections
                    }) {
                        Text(context.title)
                            .foregroundColor(context.isEmpty ? .red : .primary)
                    }
                }
                
                Section(header: Text("Options")) {
                    Toggle(isOn: $context.autoreverse) {
                        Text("autoreverse")
                    }
                    Picker(selection: $context.curve, label: Text("curve")) {
                        ForEach(AnimatingCurve.allCases, id: \.self) { curve in
                            Text(curve.name)
                        }
                    }
                    InputTextField(label: "delay", value: Binding(
                        get: { "\(self.context.delay)" },
                        set: { self.context.delay = TimeInterval(truncating: NumberFormatter().number(from: $0) ?? 0) }
                    ))
                    InputTextField(label: "duration", value: Binding(
                        get: { "\(self.context.duration)" },
                        set: { self.context.duration = TimeInterval(truncating: NumberFormatter().number(from: $0) ?? 0) }
                    ))
                    InputTextField(label: "damping", value: Binding(
                        get: { "\(self.context.damping)" },
                        set: { self.context.damping = CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0) }
                    ))
                    InputTextField(label: "velocity", value: Binding(
                        get: { "\(self.context.velocity)" },
                        set: { self.context.velocity = CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0) }
                    ))
                    Stepper(value: $context.repeatCount, in: -1...Float.greatestFiniteMagnitude, step: 1.0) {
                        Text("repeatCount: \(Int(context.repeatCount))")
                    }
                    Toggle(isOn: $context.removeOnCompletion) {
                        Text("removeOnCompletion")
                    }
                    Toggle(isOn: $context.noAnimate) {
                        Text("noAnimate")
                    }
                }
                
                ForEach(context.animations.filter({ $0.associatedProperty != .none })) { animation in
                    Section(header: Text(animation.name)) {
                        AnimationProperties(animation: animation)
                    }
                }
            }
            .disabled(!context.enabled)
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Animation", displayMode: .inline)
        .modifier(KeyboardAdapter())
    }
    
}

struct AnimationDetail_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AnimationDetail(context: AnimationContext())
                .environment(\.colorScheme, .light)
            AnimationDetail(context: AnimationContext())
                .environment(\.colorScheme, .dark)
        }
    }
}
