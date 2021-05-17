//
//  CustomTextField.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

//ログインページのテキストデザイン
struct CustomTextfield: View {
    
    @Binding var value: String
    var placeholder = "Placeholder"
    var icon = Image(systemName: "person.crop.circle")
    var color = Color("background2")
    var isSecure = false
    var onEditingChanged: ((Bool)->()) = {_ in }
    
    var body: some View {
        HStack {
            
            if isSecure{
                SecureField(placeholder, text: self.$value, onCommit: {
                    self.onEditingChanged(false)
                }).padding()
            } else {
                TextField(placeholder, text: self.$value, onEditingChanged: { flag in
                    self.onEditingChanged(flag)
                }).padding()
            }
            
            icon.imageScale(.large)
                .padding()
                .foregroundColor(color)
        }.background(color.opacity(0.2)).clipShape(Capsule())
    }
}

struct CustomTextfield_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextfield(value: .constant(""))
    }
}
