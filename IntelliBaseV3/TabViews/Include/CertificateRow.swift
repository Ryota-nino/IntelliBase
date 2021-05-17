//
//  CertificateRow.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

struct CertificateRow: View {

   var certificates = certificateData

   var body: some View {
      VStack(alignment: .leading) {
         Text("広告")
            .font(.system(size: 20))
            .fontWeight(.heavy)
            .padding(.leading, 30)

         ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
               ForEach(certificates) { item in
                CertificateView(item: item)
               }
            }
            .padding(20)
            .padding(.leading, 10)
         }
      }
   }
}

#if DEBUG
struct CertificateRow_Previews: PreviewProvider {
   static var previews: some View {
      CertificateRow()
   }
}
#endif

struct Certificate: Identifiable {
   var id = UUID()
   var url: String
   var image: String
   var width: Int
   var height: Int
}

let certificateData = [
   Certificate(url: "https://www.isehangroup.jp/kissmeproject/kaosaiyo2020/", image: "CM1", width: 230, height: 150),
   Certificate(url: "https://www.lumine.ne.jp/", image: "CM2", width: 230, height: 150),
   Certificate(url: "http://musee-pla.com/about/achievements/", image: "CM3", width: 230, height: 150),
   Certificate(url: "http://www.mount-y.com/category/all", image: "CM4", width: 230, height: 150)
]
