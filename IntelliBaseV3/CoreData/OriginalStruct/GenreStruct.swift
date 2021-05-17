//
//  GenreStruct.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation
import CoreData
import UIKit

struct GenreStruct: Identifiable {
    var id: Int
    var name: String
    var parent: Int
    
    init(id: Int) {
        let entity: CoreDataEnumManager.EntityName = .genre
        let coreData = CoreDataOperation()
        
        // init
        var nameStr = ""
        var parentId = 0
        
        // fetch
        let fetchResults: Array<Genre> = coreData.select(entity: entity, conditionStr: "id == \(id)")

        // have genre info?
        if fetchResults.count == 1 {
            // yes
            nameStr = fetchResults[0].name!
            parentId = fetchResults[0].parent_id as! Int
        } else {
            // no
            
            // init insert vslurs array
            var insertValues: Dictionary<String,Any> = [:]
            
            // get info from api
            let interface = Interface(apiFileName: "get_genre", parameter: ["id": "\(id)"], sync: true)
            while interface.isDownloading {}
            // download complete to continue ↓
            
            // success ?
            if !interface.error {
                let result = interface.content
//                print("Debug : New data -> \(interface.content)")
                if result.count == 0 {
                    // Error
                    print("Error : Api returned empty data. [ \(interface.apiPath) ]")
                } else {
                    insertValues["id"] = id as Int
                    insertValues["name"] = result[0]["name"] as! String
                    insertValues["parent_id"] = result[0]["parent_id"]
                }
            }
            // insert book info to core data
            if coreData.insert(entity: entity, values: insertValues) {
                // fetch inserted data
                let fetchResults2: Array<Genre> = coreData.select(entity: entity, conditionStr: "id == \(id)")
//                print("Debug : Inserted data -> \(fetchResults2)")
                nameStr = fetchResults2[0].name!
                parentId = fetchResults2[0].parent_id as! Int
            }
        }
        
        
        self.id = id
        self.name = nameStr
        self.parent = parentId
        
        return
    }
}
