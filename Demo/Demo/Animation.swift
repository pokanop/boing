//
//  Animation.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI
import Boing

enum AnimationTypeProperty {
    case none, direction, alpha, angle, point, rect, color, interval
}

class AnimationType: ObservableObject, Identifiable, CaseIterable, Hashable {
    
    @Published var type: AnimatingType = .boing
    @Published var direction: AnimatingDirection = .none
    @Published var alpha: CGFloat = 0
    @Published var angle: CGFloat = 0
    @Published var point: CGPoint = .zero
    @Published var rect: CGRect = .zero
    @Published var color: Color = .black
    @Published var interval: TimeInterval = 0
    
    static var allCases: [AnimationType] {
        AnimatingType.allCases.map { AnimationType(type: $0) }
    }
    
    var id: Int {
        hashValue
    }
    
    var name: String {
        type.name
    }
    
    var associatedProperty: AnimationTypeProperty {
        switch type {
        case .translate, .scale, .center: return .point
        case .rotate: return .angle
        case .backgroundColor: return .color
        case .alpha: return .alpha
        case .frame, .bounds: return .rect
        case .fadeIn, .fadeOut, .slide, .squeeze, .flip: return .direction
        case .delay: return .interval
        case .zoomIn, .zoomOut, .fall, .shake, .pop, .morph, .flash, .wobble, .swing, .boing: return .none
        }
    }
    
    init(type: AnimatingType = .boing) {
        self.type = type
    }
    
    static func == (lhs: AnimationType, rhs: AnimationType) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(alpha)
        hasher.combine(angle)
        hasher.combine("\(point)")
        hasher.combine("\(rect)")
        hasher.combine(color)
        hasher.combine(interval)
    }
    
}

class AnimationContext: ObservableObject, Identifiable {
    
    let id: UUID = UUID()
    @Published var animations: [AnimationType] = []
    @Published var delay: TimeInterval = 0.0
    @Published var duration: TimeInterval = 0.7
    @Published var curve: AnimatingCurve = .easeInOut
    @Published var damping: CGFloat = 0.7
    @Published var velocity: CGFloat = 0.7
    @Published var repeatCount: Float = 1.0
    @Published var autoreverse: Bool = false
    
    var title: String {
        animations.count > 0 ? animations.map { $0.type.name }.joined(separator: ", ") : "configure"
    }
    
    var isEmpty: Bool {
        animations.isEmpty
    }
    
    func addAnimation() {
        animations.append(AnimationType())
    }

}

extension Color {
    
    var uiColor: UIColor {
        switch self {
        case .black: return .black
        case .blue: return .blue
        case .gray: return .gray
        case .green: return .green
        case .orange: return .orange
        case .pink: return .systemPink
        case .purple: return .purple
        case .red: return .red
        case .white: return .white
        case .yellow: return .yellow
        default: return .black
        }
    }
    
}
