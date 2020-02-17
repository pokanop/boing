//
//  AnimationProperties.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

struct AnimationProperties: View {
    
    @ObservedObject var animation: AnimationType
    
    var body: some View {
        Group {
            if animation.associatedProperty == .float {
                InputTextField(label: "float", value: Binding(
                    get: { "\(self.animation.float)" },
                    set: { self.animation.float = CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0) }
                ))
            } else if animation.associatedProperty == .direction {
                Picker(selection: $animation.direction, label: Text("direction")) {
                    ForEach(AnimatingDirection.allCases, id: \.self) { direction in
                        Text(direction.name)
                    }
                }
            } else if animation.associatedProperty == .point {
                InputTextField(label: "x", value: Binding(
                    get: { "\(self.animation.point.x)" },
                    set: { self.animation.point = CGPoint(
                        x: CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0),
                        y: self.animation.point.y)
                    }
                ))
                InputTextField(label: "y", value: Binding(
                    get: { "\(self.animation.point.y)" },
                    set: { self.animation.point = CGPoint(
                        x: self.animation.point.x,
                        y: CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0))
                    }
                ))
            } else if animation.associatedProperty == .size {
                InputTextField(label: "width", value: Binding(
                    get: { "\(self.animation.size.width)" },
                    set: { self.animation.size = CGSize(
                        width: CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0),
                        height: self.animation.size.height)
                    }
                ))
                InputTextField(label: "height", value: Binding(
                    get: { "\(self.animation.size.height)" },
                    set: { self.animation.size = CGSize(
                        width: self.animation.size.height,
                        height: CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0))
                    }
                ))
            } else if animation.associatedProperty == .rect {
                InputTextField(label: "x", value: Binding(
                    get: { "\(self.animation.rect.origin.x)" },
                    set: { self.animation.rect = CGRect(
                        origin: CGPoint(
                            x: CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0),
                            y: self.animation.rect.origin.y),
                        size: self.animation.rect.size)
                    }
                ))
                InputTextField(label: "y", value: Binding(
                    get: { "\(self.animation.rect.origin.y)" },
                    set: { self.animation.rect = CGRect(
                        origin: CGPoint(
                            x: self.animation.rect.origin.x,
                            y: CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0)),
                        size: self.animation.rect.size)
                    }
                ))
                InputTextField(label: "width", value: Binding(
                    get: { "\(self.animation.rect.size.width)" },
                    set: { self.animation.rect = CGRect(
                        origin: self.animation.rect.origin,
                        size: CGSize(
                            width: CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0),
                            height: self.animation.rect.size.height))
                    }
                ))
                InputTextField(label: "height", value: Binding(
                    get: { "\(self.animation.rect.size.height)" },
                    set: { self.animation.rect = CGRect(
                        origin: self.animation.rect.origin,
                        size: CGSize(
                            width: self.animation.rect.size.width,
                            height: CGFloat(truncating: NumberFormatter().number(from: $0) ?? 0)))
                    }
                ))
            } else if animation.associatedProperty == .color {
                ColorPicker(selections: [animation.color]) { colors in
                    self.animation.color = colors.first!
                }
            } else if animation.associatedProperty == .interval {
                InputTextField(label: "interval", value: Binding(
                    get: { "\(self.animation.interval)" },
                    set: { self.animation.interval = TimeInterval(truncating: NumberFormatter().number(from: $0) ?? 0) }
                ))
            }
        }
    }
    
}

struct AnimationProperties_Previews: PreviewProvider {
    static var previews: some View {
        AnimationProperties(animation: AnimationType())
    }
}
