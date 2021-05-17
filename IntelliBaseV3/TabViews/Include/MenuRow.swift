//
//  MenuRow.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

struct MenuRow: View {
    
    var image = "creditcard"
    var text = "アカウント"
    
    var body: some View {
        return HStack {
            Image(systemName: image)
                .imageScale(.large)
                .foregroundColor(Color("icons"))
                .frame(width: 32, height: 32)
            
            Text(text)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}
