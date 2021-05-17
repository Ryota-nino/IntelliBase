//
//  Settings.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

struct Settings: View {

   @State var receive = false
   @State var number = 1
   @State var selection = 1
   @State var date = Date()
   @State var email = ""
   @State var submit = false

   var body: some View {
      NavigationView {
         Form {
            Toggle(isOn: $receive) {
               Text("通知")
            }
            Stepper(value: $number, in: 1...10) {
               Text("１週間に \(number) 回通知")
            }
            Picker(selection: $selection, label: Text("お気に入りの本")) {
                //登録してるやつを表示
               Text("SwiftUI").tag(1)
               Text("React").tag(2)
            }
            DatePicker(selection: $date, label: {
               Text("現在時刻")
            })
            Section(header: Text("Email")) {
               TextField("あなたのメールアドレス: ", text: $email)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Button(action: { self.submit.toggle() }) {
               Text("変更を保存")
            }
            .alert(isPresented: $submit, content: {
               Alert(title: Text("メールアドレスを変更しました"), message: Text("Email: \(email)"))
            })
         }
         .navigationBarTitle("アカウント")
      }
   }
}

#if DEBUG
struct Settings_Previews: PreviewProvider {
   static var previews: some View {
      Settings()
   }
}
#endif
