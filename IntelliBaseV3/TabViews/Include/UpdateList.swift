//
//  UpdateList.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

struct UpdateList: View {

   var updates = updateData
   @ObservedObject var store = UpdateStore(updates: updateData)

   func addUpdate() {
      store.updates.append(Update(image: "Certificate1", title: "New Title", text: "New Text", date: "JUL 1"))
   }

   func move(from source: IndexSet, to destination: Int) {
      store.updates.swapAt(source.first!, destination)
   }

   var body: some View {
      NavigationView {
         List {
            ForEach(store.updates) { item in
               NavigationLink(destination: UpdateDetail(title: item.title, text: item.text, image: item.image)) {
                  HStack(spacing: 12.0) {
                     Image(item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .background(Color("background"))
                        .cornerRadius(20)

                     VStack(alignment: .leading) {
                        Text(item.title)
                           .font(.headline)

                        Text(item.text)
                           .lineLimit(2)
                           .lineSpacing(4)
                           .font(.subheadline)
                           .frame(height: 50.0)

                        Text(item.date)
                           .font(.caption)
                           .fontWeight(.bold)
                           .foregroundColor(.gray)
                     }
                  }
               }
               .padding(.vertical, 8.0)
            }
            .onDelete { index in
               self.store.updates.remove(at: index.first!)
            }
            .onMove(perform: move)
         }
         .navigationBarTitle(Text("お知らせ"))
         .navigationBarItems(
            //leading: Button(action: addUpdate) { Text("Add Update") },
            trailing: EditButton()
         )
      }
   }
}

#if DEBUG
struct UpdateList_Previews: PreviewProvider {
   static var previews: some View {
      UpdateList()
   }
}
#endif

struct Update: Identifiable {
   var id = UUID()
   var image: String
   var title: String
   var text: String
   var date: String
}

let updateData = [
   Update(image: "questionIcon", title: "Intelli-Baseの使い方", text: "Intelli-Baseをダウンロードしていただきありがとうございます。使用方法についてはここに記載しております。", date: "JUN 26"),
//   Update(image: "Illustration2", title: "Framer X", text: "Learn how to build custom views and controls in SwiftUI with advanced composition, layout, graphics, and animation. See a demo of a high performance, animatable control and watch it made step by step in code. Gain a deeper understanding of the layout system of SwiftUI.", date: "JUN 11"),
]
