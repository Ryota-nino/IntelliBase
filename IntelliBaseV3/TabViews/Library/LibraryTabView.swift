//
//  LibraryTabView.swift
//  DesignCode
//
//  Created by 二宮良太 on 2020/12/07.
//  Copyright © 2020 Mithun. All rights reserved.
//

import SwiftUI

struct LibraryTabView: View {
    @State var show = false
    @State var showProfile = false
    
    var body: some View {
        ZStack(alignment: .top) {
            LibraryList()
        }
        .background(Color("background1"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct TextCardView: View {
    //var card: TwentyFourGame<String>.Card
    var body: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 9).stroke()
                //Text(card.content)
                    //.font(Font.system(size: min(geo.size.width, geo.size.height) * 0.7))
            }
        }
    }
}

#if DEBUG
struct LibraryTabView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryTabView()
    }
}
#endif


