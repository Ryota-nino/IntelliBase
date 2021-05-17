//
//  DrawingManager.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2021/01/22.
//

///**
/**

DrawingDocApp
CREATED BY:  DEVTECHIE INTERACTIVE, INC. ON 10/10/20
COPYRIGHT (C) DEVTECHIE, DEVTECHIE INTERACTIVE, INC

*/

import SwiftUI

class DrawingManager: ObservableObject {
    @Published var docs: [DrawingDocument]
    
    init(noteId: Int) {
        docs = CoreDataManager.shared.getNoteData(noteId: noteId)
    }
    
    func update(data: Data, for id: UUID) {
        if let index = self.docs.firstIndex(where: {$0.id == id}) {
            self.docs[index].data = data
            CoreDataManager.shared.updateData(data: self.docs[index])
            // 名前からノートIDを抽出
            let name = docs[index].name
            let noteId: String = String(name[name.range(of: "_note")!.upperBound..<name.range(of: "_page")!.lowerBound])
            // update note info
            _ = CoreDataOperation().update(entity: .note, conditionStr: "id = \(noteId)", values: ["update_date":Date()])
            
            NoteManager.shared.moveToFirst(noteId: Int(noteId)!)
        }
    }
    
    func getData(for id: UUID) -> Data {
        if let doc = self.docs.first(where: {$0.id == id}) {
            return doc.data
        }
        return Data()
    }
    
    func addData(doc: DrawingDocument) {
        docs.append(doc)
        CoreDataManager.shared.addData(doc: doc)
    }
    
    func delete(for indexSet: IndexSet) {
        for index in indexSet {
            CoreDataManager.shared.deleteData(data: docs[index])
            docs.remove(at: index)
        }
    }
}

