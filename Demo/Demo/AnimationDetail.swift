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
            Section {
                MultiSelectList(items: AnimatingType.allCases, selections: $context.animations)
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
