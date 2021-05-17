//
//  thumbnailWithInfoIconsView.swift
//  IntelliBaseV3
//
//  Created by てぃん on 2021/02/18.
//

import SwiftUI
import UIKit

struct thumbnailWithInfoIconsView: View {
    
    var uiImage: UIImage?
    var share: Bool
    var own: Bool
    var title: String
    
    init(note: NoteStruct, thumbnailUIImage: UIImage?) {
        uiImage = thumbnailUIImage
        share = note.share
        own = note.account_id == note.share_account_id
        title = note.title
    }
    
    var body: some View {
        VStack {
            ZStack {
                if let _uiImage = uiImage {
                    Image(uiImage: _uiImage)
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 240, height: 330)
                        .padding(.bottom, 30)
                }
                HStack {
                    EditedMark(icon: "pencil.and.outline")
                    if share {
                        if  own {
                                EditedMark(icon: "link")
                        } else {
                            EditedMark(icon: "link.icloud")
                        }
                    }
                }.frame(width: 250, height: 370, alignment: .topLeading)
            }
            Text("\(title)")
                .offset(y: -32)
        }
    }
}

struct thumbnailWithInfoIconsView_Previews: PreviewProvider {
    static var previews: some View {
        thumbnailWithInfoIconsView(note: NoteStruct(id: 3), thumbnailUIImage: nil)
    }
}
