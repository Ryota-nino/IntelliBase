//
//  EditViewManager.swift
//  IntelliBaseV3
//
//  Created by てぃん on 2021/01/29.
//

import SwiftUI

class EditViewManager: ObservableObject {
    @Published var view: DocumentEditView?
    
    init() {}
    
    func loadView(pdfKitView: Binding<PDFKitView>, noteId: Int, pageNum: Int = 1) {
        var readOnly = false
        let notes: [Note] = CoreDataOperation().select(entity: .note, conditionStr: "id = \(noteId)")
        if notes.count == 1 {
            if notes[0].account_id != notes[0].share_account_id {
                readOnly = true
            }
            view = DocumentEditView(pdfKitView: pdfKitView, noteId: noteId, readOnly: readOnly, pageNum: pageNum)
        }
    }
}
