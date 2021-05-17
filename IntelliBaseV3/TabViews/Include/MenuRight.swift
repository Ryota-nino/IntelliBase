//
//  MenuRight.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

struct MenuRight: View {
    
    @Binding var show: Bool
    @State var showUpdate = false
    @State var showLoginStatus = false
    
    var body: some View {
        return ZStack(alignment: .topTrailing) {
            HStack {
                Button(action: { self.showLoginStatus.toggle() }) {
                    CircleButton(icon: "person.crop.circle")
//                        .sheet(isPresented: self.$showLoginStatus) { LoginView() }
                }
                .disabled(true)
                Button(action: { self.showUpdate.toggle() }) {
                    CircleButton(icon: "bell")
                        .sheet(isPresented: self.$showUpdate) { UpdateList() }
                }
            }
        }
    }
}
