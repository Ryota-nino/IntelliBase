//
//  Home.swift
//  DesignCode
//
//  Created by Mithun x on 7/12/19.
//  Copyright © 2019 Mithun. All rights reserved.
//

import SwiftUI

let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
let screen = UIScreen.main.bounds

struct HomeTabView: View {
    
    @State var show = false
    @State var showProfile = false
    
    var body: some View {
        ZStack(alignment: .top) {
            HomeList()
        }
        .background(Color("background1"))
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
            .previewDevice("iPhone X")
    }
}
#endif
