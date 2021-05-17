//
//  PlusButton.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/02/18.
//

import SwiftUI

struct PlusButton: View {
    
    var icon = "plus"
    var width: CGFloat = 150
    var height: CGFloat = 250
    
    var body: some View {
        return HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .font(.system(size: 80))
        }
        .frame(width: width, height: height)
        .background(Color("button"))
        .cornerRadius(30)
        .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
        .opacity(0.7)
    }
}
