//
//  AnimationDetail.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

struct AnimationDetail: View {
    
    @Binding var context: AnimationContext
    
    var body: some View {
        Form {
            Section(header: Text("Types")) {
                NavigationLink(destination: MultiSelectList(items: AnimationType.allCases, selections: $context.animations)) {
                    Text(context.title)
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
                HStack {
                    Text("delay")
                    Spacer()
                    TextField("value", text: Binding(
                        get: { "\(self.context.delay)" },
                        set: { self.context.delay = TimeInterval(truncating: NumberFormatter().number(from: $0) ?? 0) }
                    ))
                    .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("duration")
                    Spacer()
                    TextField("value", text: Binding(
                        get: { "\(self.context.duration)" },
                        set: { self.context.duration = TimeInterval(truncating: NumberFormatter().number(from: $0) ?? 0) }
                    ))
                    .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("damping")
                    Spacer()
                    TextField("value", text: Binding(
                        get: { "\(self.context.damping)" },
                        set: { self.context.damping = CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0) }
                    ))
                    .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("velocity")
                    Spacer()
                    TextField("value", text: Binding(
                        get: { "\(self.context.velocity)" },
                        set: { self.context.velocity = CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0) }
                    ))
                    .multilineTextAlignment(.trailing)
                }
                VStack {
                    Text("repeatCount")
                    Stepper(value: $context.repeatCount, in: -1...Float.greatestFiniteMagnitude, step: 1.0) {
                        Text("\(Int(context.repeatCount))")
                    }
                }
            }
            
            ForEach(context.animations.indexed(), id: \.1.id) { index, animation in
                Section(header: Text(animation.name)) {
                    AnimationProperties(animation: self.$context.animations[index])
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Animation", displayMode: .inline)
    }
    
}

struct AnimationDetail_Previews: PreviewProvider {
    @State static var context = AnimationContext()
    
    static var previews: some View {
        return AnimationDetail(context: AnimationDetail_Previews.$context)
    }
}
