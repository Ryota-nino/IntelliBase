//
//  CircleButton.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

struct CircleButton: View {
    
    var icon = "person.crop.circle"
    
    var body: some View {
        return HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)
        }
        .frame(width: 44, height: 44)
        .background(Color("button"))
        .cornerRadius(30)
        .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
    }
}
