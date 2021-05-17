//
//  Home.swift
//  DesignCode
//
//  Created by Mithun x on 7/12/19.
//  Copyright © 2019 Mithun. All rights reserved.
//

import SwiftUI

//let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//let screen = UIScreen.main.bounds

struct Application: View {
    
    @State var show = false
    @State var showProfile = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var accountId: Int = 0
    
    init() {}
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView{
                HomeTabView()
                    .navigationBarHidden(true)
                    .animation(Animation.linear)
                    .tabItem {
                        HStack {
                            Image(systemName: "house.fill")
                        }
                    }.tag(1)
                LibraryTabView()
                    .navigationBarHidden(true)
                    .animation(Animation.linear)
                    .tabItem {
                        VStack {
                            Image(systemName: "book.fill")
                        }
                    }.tag(2)
            }
            .blur(radius: show ? 20 : 0)
            .scaleEffect(showProfile ? 0.95 : 1)
            .animation(.default)
            
            HStack {
                MenuButton(show: $show)
                    .offset(x: -40, y: 0)
                Spacer()
                
                MenuRight(show: $showProfile)
                    .offset(x: -16, y: 0)
            }
            .edgesIgnoringSafeArea(.top)
            
            .offset(y: showProfile ? statusBarHeight : 80)
            .animation(.spring())
            
            MenuView(show: $show)
                .edgesIgnoringSafeArea(.top)
        }
        .onAppear(perform: {
            let coreData = CoreDataOperation()
            // ログイン中のアカウントを取得
            let accounts: Array<Account> = coreData.select(entity: .account, conditionStr: "login = true")
            if accounts.count == 0 {
                // Back to login view.
                self.mode.wrappedValue.dismiss()
            } else {
                self.accountId = accounts[0].id as! Int
            }
            
//            print("Debug : Menu loaded. id = \(accountId).")
            
            // get purchased books
            let dataGetter = GetNewData()
            _ = dataGetter.download(entity: .book, id: self.accountId)
            // wait download
            while dataGetter.interface!.isDownloading {}
        })
    }
}
