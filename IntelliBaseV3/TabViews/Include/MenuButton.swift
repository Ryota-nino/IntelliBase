//
//  MenuButton.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

struct MenuButton: View {
    @Binding var show: Bool
    
    var body: some View {
        return ZStack(alignment: .topLeading) {
            Button(action: { self.show.toggle() }) {
                HStack {
                    Spacer()
                    
                    Image(systemName: "list.dash")
                        .foregroundColor(.primary)
                }
                .padding(.trailing, 18)
                .frame(width: 90, height: 60)
                .background(Color("button"))
                .cornerRadius(30)
                .shadow(color: Color("buttonShadow"), radius: 20, x: 0, y: 20)
            }
            Spacer()
        }
    }
}
