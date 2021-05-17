//
//  DocumentStruct.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation

struct DocumentStruct: Identifiable {
    // ノートまたは本のid
    var id: Int
    // ノートかどうかのBool値
    var isNote: Bool
    // 本情報
    var book: BookStruct
    // ノート情報（オプション）
    var note: NoteStruct? = nil
    
    init(id: Int, isNote: Bool = false) {
        
        self.id = id
        self.isNote = isNote
        
        // is note?
        if(self.isNote) {
            // note
            self.note = NoteStruct(id: id)
            // get book noted
            self.book = BookStruct(id: note!.book_id)
        } else {
            // book
            self.book = BookStruct(id: id)
        }
        
        return
    }
}
