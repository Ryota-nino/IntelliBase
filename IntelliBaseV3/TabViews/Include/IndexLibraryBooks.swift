//
//  IndexLibraryBook.swift
//  IntelliBaseV3
//
//  Created by 二宮良太 on 2021/01/28.
//

import SwiftUI

struct IndexLibraryBooks: View {
    var noteManager: NoteManager = NoteManager.shared
    var ids: Array<Array<Any>> = []
    var partition: Bool
    var num = 0
    
    init(
        ids: Array<Any> = [],
        partition: Bool = false
    ) {
        for id in ids {
            self.ids.append([id])
        }
        self.partition = partition
        
        return
    }
    
    var body: some View {
        ForEach(0..<self.ids.count) {i in
            if i < ids.count {
                if ids[i].count == 2 {
                    LibraryBooksThumbnail(id: ids[i][0] as! Int, isNote: ids[i][1] as! Bool)
                } else {
                    LibraryBooksThumbnail(id: ids[i][0] as! Int)
                }
            }
        }
    }
}

struct IndexLibraryBooks_Previews: PreviewProvider {
    static var previews: some View {
        IndexLibraryBooks()
    }
}
