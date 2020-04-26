//
//  CenteredButton.swift
//  Demo
//
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct CenteredButton: View {
    
    let title: String
    let action: () -> ()
    
    var body: some View {
        HStack {
            Spacer()
            Button(title, action: action)
            Spacer()
        }
    }
    
}

struct CenteredButton_Previews: PreviewProvider {
    static var previews: some View {
        CenteredButton(title: "Action", action: {})
    }
}
