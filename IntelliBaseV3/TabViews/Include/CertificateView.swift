//
//  CertificateView.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/25.
//

import SwiftUI

struct CertificateView: View {

   var item = Certificate(url: "https://www.isehangroup.jp/kissmeproject/kaosaiyo2020/", image: "CM1", width: 340, height: 220)

   var body: some View {
      return VStack {
         HStack {
            VStack(alignment: .leading) {
            }
         }
        Button(action: {
            if let url = URL(string: item.url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(item.image)
                    .resizable()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight:
                    .infinity)
            }
        }
         
      }
      .frame(width: CGFloat(item.width), height: CGFloat(item.height))
      .cornerRadius(10)
      .shadow(radius: 10)
   }
}
