//
//  EditedMark.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/02/18.
//

import SwiftUI

struct EditedMark: View {
    
    var icon = "pencil.and.outline"
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.primary)
                .font(.system(size: 25))
        }
        .frame(width: 50, height: 50)
        .background(Color("button"))
        .cornerRadius(30)
        .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
    }
}
