//
//  SectionOfBookShelfView.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import SwiftUI

struct SectionOfBookShelfView: View {
    var ids: Array<Array<Any>>
    var partition: Bool
    
    init(
        ids: Array<Array<Any>> = [[1,false],[1],[1,false],[1,false]],
        partition: Bool = false
    ) {
        self.ids = ids
        self.partition = partition
        
        return
    }
    
    var body: some View {
        ForEach(0..<self.ids.count) {i in
            if i < ids.count {
                if ids[i].count == 2 {
//                GeometryReader { geometry in
                    DocumentThumbnailView(id: ids[i][0] as! Int, isNote: ids[i][1] as! Bool)
//                        .rotation3DEffect(Angle(degrees:
//                                                    Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
//                }
//                .frame(width: 246, height: 360)
                } else {
                    DocumentThumbnailView(id: ids[i][0] as! Int)
                }
            }
        }
    }
}

struct SectionOfBookShelfView_Previews: PreviewProvider {
    static var previews: some View {
        SectionOfBookShelfView()
    }
}
