//
//  CoreDataManager.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2021/01/22.
//

///**
/**

DrawingDocApp
CREATED BY:  DEVTECHIE INTERACTIVE, INC. ON 10/9/20
COPYRIGHT (C) DEVTECHIE, DEVTECHIE INTERACTIVE, INC

*/

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntelliBaseV3")
        container.loadPersistentStores { (storeDesc, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addData(doc: DrawingDocument) {
        let drawing = DrawingDoc(context: persistentContainer.viewContext)
        drawing.data = doc.data
        drawing.id = doc.id
        drawing.name = doc.name
        
        saveContext()
    }
    
    func getData() -> [DrawingDocument] {
        let request: NSFetchRequest<DrawingDoc> = DrawingDoc.fetchRequest()
        request.returnsObjectsAsFaults = false
        var fetchResults = [DrawingDocument]()
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            for data in result {
                fetchResults.append(DrawingDocument(id: data.id ?? UUID(), data: data.data ?? Data(), name: data.name ?? ""))
            }
        } catch {
            print("Fetching failed")
        }
        
        return fetchResults
    }
    
    func updateData(data: DrawingDocument) {
        let request: NSFetchRequest<DrawingDoc> = DrawingDoc.fetchRequest()
        let predicate = NSPredicate(format: "id = %@", data.id as CVarArg)
        request.predicate = predicate
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            let obj = results.first
            obj?.setValue(data.data, forKey: "data")
            saveContext()
        } catch {
            print("Error saving document update.")
        }
    }
    
    func deleteData(data: DrawingDocument) {
        let request: NSFetchRequest<DrawingDoc> = DrawingDoc.fetchRequest()
        request.includesPropertyValues = false
        let predicate = NSPredicate(format: "id = %@", data.id as CVarArg)
        request.predicate = predicate
        
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            for item in results {
                persistentContainer.viewContext.delete(item)
            }
            
            saveContext()
        } catch {
            print("Error deleting document from database")
        }
    }
    
    // original func: get documents from note id
    func getNoteData(noteId: Int) -> [DrawingDocument] {
        let request: NSFetchRequest<DrawingDoc> = DrawingDoc.fetchRequest()
        request.returnsObjectsAsFaults = false
        // ノートIDで絞り込み
        request.predicate = NSPredicate(format: "name CONTAINS %@","_note\(noteId)_page")
        // ページ番号で昇順にソート
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        var fetchResults = [DrawingDocument]()
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            for data in result {
                fetchResults.append(DrawingDocument(id: data.id ?? UUID(), data: data.data ?? Data(), name: data.name ?? ""))
                // ノートのIDから絞り込み
//                if data.name!.contains("_note\(noteId)_page") {
//                    fetchResults.append(DrawingDocument(id: data.id ?? UUID(), data: data.data ?? Data(), name: data.name ?? ""))
//                }
            }
        } catch {
            print("Fetching failed")
        }
        
        return fetchResults
    }
}

