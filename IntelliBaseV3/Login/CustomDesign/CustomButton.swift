//
//  CustomButton.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

//ログインページのボタンデザイン
struct CustomButton: View {
    var text = "Next"
    var action: (()->()) = {}
    
    var body: some View {
      Button(action: {
        self.action()
      }) {
        HStack {
            Text(text)
                .bold()
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.vertical)
                .accentColor(Color.white)
                .background(Color.blue)
                .cornerRadius(30)
            }
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
    }
}
