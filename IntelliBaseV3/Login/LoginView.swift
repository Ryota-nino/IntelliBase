//
//  LoginView.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import SwiftUI

struct LoginView: View {
    
    private var skipLogin: Bool = false
    
    @State private var email = "test@intellibase.com"
    @State private var password = "testpass"
    @State private var formOffset: CGFloat = 0
    @State private var presentSignupSheet = false
    @State private var presentPasswordRecoverySheet = false
    @State var accountId: Int = 0
    @State var navActive: Bool = false
    
    init(email: String = "", id: Int? = nil, skipLogin: Bool = false) {
        self.email = email
        
        // If skip login is TRUE, but id does not set.
        if skipLogin {
            if id == nil {
                print("Error : Skipping login need account's id. Found id is \(String(describing: id))")
            } else {
//                print("Debug : login skipped. id = \(id!)")
                self.accountId = id!
                self.skipLogin = true
            }
        }
    }

    
    var body: some View {
        
        VStack(spacing: 40) {
            Image("Logo")
            Text("ログイン")
                .font(.title)
                .bold()
            VStack {
                CustomTextfield(value: self.$email, placeholder: "Email", icon: Image(systemName: "at"), onEditingChanged: { flag in
                    withAnimation {
                        self.formOffset = flag ? -150 : 0
                    }
                })
                CustomTextfield(value: self.$password, placeholder: "Password", icon: Image(systemName: "lock"), isSecure: true)
                CustomButton(text: "Login") {
                    let loginVerify = LoginVerify(email: self.email, password: self.password)
//                    print("Debug : Login verify \(loginVerify.verify).")
                    
                    if loginVerify.verify {
                        self.accountId = loginVerify.id
                        // 表示するノートをログイン中のアカウントのものへ切り替え
                        NoteManager.shared.fetch()
                        // Navigation to menu.
                        navActive = true
                    }
                }
                NavigationLink(
                    destination:
                        Application()
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true),
                    isActive:
                        $navActive
                ){}
                .onAppear(perform: {
                    if skipLogin {
                        navActive = true
                    }
                })
            }
            
            Button(action: {
                self.presentSignupSheet.toggle()
            }) {
              HStack {
                Text("アカウントを持っていませんか? アカウント作成はこちら.")
                    .accentColor(Color.accentColor)
                  }
              }
            .sheet(isPresented: self.$presentSignupSheet) {
                  //SignupView()
              }
            
            Button(action: {
                self.presentPasswordRecoverySheet.toggle()
            }) {
              HStack {
                Text("パスワードを忘れましたか？").accentColor(Color.purple)
                  }
              }.sheet(isPresented: self.$presentPasswordRecoverySheet) {
                //RecoverPasswordView(presentPasswordRecoverySheet: self.$presentPasswordRecoverySheet)
              }
            
        }
        .padding()
        .offset(y: self.formOffset)
        .onAppear(perform: {
//            print("Debug : Login view loaded.")
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
