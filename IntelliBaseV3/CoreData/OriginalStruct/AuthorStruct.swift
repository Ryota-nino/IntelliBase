//
//  AuthorStruct.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation
import CoreData
import UIKit

struct AuthorStruct: Identifiable {
    var id: Int
    var name: String
    
    init(id: Int) {
        let entity: CoreDataEnumManager.EntityName = .author
        let coreData = CoreDataOperation()
        
        // init
        var nameStr = ""
        
        // fetch
        let fetchResults: Array<Author> = coreData.select(entity: entity, conditionStr: "id == \(id)")

        // have book info?
        if fetchResults.count == 1 {
            // yes
            nameStr = fetchResults[0].name!
        } else {
            // no
            
            // init insert vslurs array
            var insertValues: Dictionary<String,Any> = [:]
            
            // get info from api
            let interface = Interface(apiFileName: "get_author", parameter: ["id": "\(id)"], sync: true)
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
                }
            }
            // insert book info to core data
            if coreData.insert(entity: entity, values: insertValues) {
                // fetch inserted data
                let fetchResults2: Array<Author> = coreData.select(entity: entity, conditionStr: "id == \(id)")
//                print("Debug : Inserted data -> \(fetchResults2)")
                nameStr = fetchResults2[0].name!
            }
        }
        
        self.id = id
        self.name = nameStr
        
        return
    }
}

