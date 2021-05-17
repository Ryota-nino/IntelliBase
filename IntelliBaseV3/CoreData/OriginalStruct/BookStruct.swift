//
//  BookStruct.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation
import CoreData
import UIKit
import SwiftUI

struct BookStruct: Identifiable {
    // Book info
    var id: Int
    var title: String
    var auther: AuthorStruct
    var genre: GenreStruct
    // Note info
    var notes: [NoteStruct] = []
    
    var thumbnailUIImage: UIImage? = nil
    
    init(id: Int){
        let entity: CoreDataEnumManager.EntityName = .book
        let coreData = CoreDataOperation()
        
        // init
        var title: String = ""
        var authorId: Int = 1
        var genreId: Int = 1
        
        // fetch
        let fetchResults: Array<Book> = coreData.select(entity: entity, conditionStr: "id == \(id)")

        // have book info?
        if fetchResults.count == 1 {
            // yes
            title = fetchResults[0].title!
            authorId = fetchResults[0].author_id as! Int
            genreId = fetchResults[0].genre_id as! Int
            
            do {
                let thumbnailData = try Data(contentsOf: (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]).appendingPathComponent("thumbnail_\(id).png"))
                thumbnailUIImage = UIImage(data: thumbnailData)
            } catch let error {
                print(error)
            }
        } else {
            // no
            
            // delete duplication
            if fetchResults.count > 1 {
                // Debug
                for result in fetchResults {
                    print("Error : Duplication book. \(String(describing: result.id!))")
                }
                _ = coreData.delete(entity: entity, conditionStr: "id == \(id)")
            }
            
            // init insert vslurs array
            var insertValues: Dictionary<String,Any> = [:]
            
            // get info from api
            let interface = Interface(apiFileName: "get_book", parameter: ["id": "\(id)"], sync: true)
            while interface.isDownloading {}
            // download complete to continue ↓
            
            // success ?
            if !interface.error {
                let result = interface.content
                if result.count == 0 {
                    // Error
                    print("Error : Api returned empty data. [ \(interface.apiPath) ]")
                } else {
                    insertValues["id"] = id
                    insertValues["title"] = result[0]["title"]
                    insertValues["author_id"] = result[0]["author_id"]
                    insertValues["genre_id"] = result[0]["genre_id"]
                    insertValues["download_date"] = 0
                }
                // insert book info to core data
                if coreData.insert(entity: entity, values: insertValues) {
                    // fetch inserted data
                    let fetchResults2: Array<Book> = coreData.select(entity: entity, conditionStr: "id == \(id)", sort: ["id":false])
                    title = fetchResults2[0].title!
                    authorId = fetchResults2[0].author_id as! Int
                    genreId = fetchResults2[0].genre_id as! Int
                }
            }
        }
        
        self.id = id
        self.title = title
        self.auther = AuthorStruct(id: authorId)
        self.genre = GenreStruct(id: genreId)
        
        // ノートを取得
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let predicateBookId = NSPredicate(format: "book_id == %@", NSNumber(value: id))
        let predicateAccount = NSPredicate(format: "account_id == %@", (CoreDataOperation().select(entity: .account, conditionStr: "login == true")[0] as! Account).id!)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [predicateBookId, predicateAccount])
        req.predicate = andPredicate
        
        let sortDescripter = NSSortDescriptor(key: "update_date", ascending: false)
        req.sortDescriptors = [sortDescripter]
        
        do {
            let writings: [Note] = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(req) as! [Note]
            for writing in writings {
                notes.append(NoteStruct(id: writing.id as! Int))
            }
        } catch let error {
            NSLog("\(error)")
        }
        
        return
    }
}

