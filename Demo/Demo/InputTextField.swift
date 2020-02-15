//
//  InputTextField.swift
//  Demo
//
//  Created by Sahel Jalal on 2/14/20.
//  Copyright © 2020 Pokanop Apps. All rights reserved.
//

import SwiftUI

struct InputTextField: View {
    
    var label: String
    var placeholder: String = "value"
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField(placeholder, text: $value).multilineTextAlignment(.trailing)
        }
    }
    
}

struct InputTextField_Previews: PreviewProvider {
    @State static var value: String = ""
    
    static var previews: some View {
        InputTextField(label: "label", placeholder: "value", value: InputTextField_Previews.$value)
    }
}
