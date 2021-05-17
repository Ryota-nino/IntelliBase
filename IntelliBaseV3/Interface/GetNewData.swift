//
//  GetNewGenre.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation
import CoreData

class GetNewData {
    let coreData = CoreDataOperation()
    var status = true
    var interface: Interface? = nil
    
    init() {}
    
    func download(entity: CoreDataEnumManager.EntityName, id: Int? = nil) -> Bool {
        // get saved data id desc
        var savedData:Array<Any> = []
        // get new data info
        var apiFileName = ""
        var paramArray: Dictionary<String,String> = [:]
        switch entity {
        case .genre:
                savedData = coreData.select(entity: entity, sort: ["id":false])
                apiFileName = "get_genres"
                break
        case .book:
                apiFileName = "get_purchased_books"
                if let id = id {
                    paramArray["id"] = "\(id)"
                    savedData = coreData.select(entity: .purchase, conditionStr: "account_id == \(id)", sort: ["id":false])
                    _ = GetNewData().download(entity:.purchase, id: id)
                } else {
                    status = false
                    print("Error : Parameter user id does not exists. GetNewData(entityName: \"Book\", id: ?")
                    return false
                }
                break
        case .purchase:
                apiFileName = "get_purchases"
                if let id = id {
                    paramArray["id"] = "\(id)"
                    savedData = coreData.select(entity: entity, conditionStr: "account_id = \(id)", sort: ["id":false])
                } else {
                    status = false
                    print("Error : Parameter user id does not exists. GetNewData(entityName: \"Purchase\", id: ?")
                    return false
                }
                break
            default:
                apiFileName = "get_genres"
        }
        var alreadyGetId = "0"
        if savedData.count != 0 {
            switch entity {
            case .genre:
                alreadyGetId = "\((savedData[0] as! Genre).id as! Int)"
                break

            case .book:
                alreadyGetId = "\((savedData[0] as! Purchase).id as! Int)"
                break

            case .purchase:
                alreadyGetId = "\((savedData[0] as! Purchase).id as! Int)"
                break

            default : break
            }
        }
        paramArray["already_get"] = alreadyGetId
        let interface = Interface(apiFileName: apiFileName, parameter: paramArray, sync: true)
        self.interface = interface
        while interface.isDownloading {}
        
        
        // success ?
        if !interface.error {
            let newData = interface.content
//            print("Debug : New data from \(apiFileName) -> \(newData)")
            // new data exists ?
            if newData.count > 0 {
                // loop in result
                for record in newData {
                    if entity == .purchase {
                        print("")
                    }
                    var insertValues: Dictionary<String,Any> = [:]
                    // loop in record
                    for (key, value) in record {
                        insertValues[key] = value
                    }
                    if entity == .book {
                        insertValues["download_date"] = 0
                        insertValues["download_thumbnail_date"] = 0
                    }
                    // insert new data
                    if coreData.insert(entity: entity, values: insertValues) {
                        // fetch inserted data
//                        _ = coreData.select(entityName: entityName, conditionStr: "id = \(String(describing: id))", sort: ["id":false])
//                        print("Debug : Record added to \(entityName) -> \(insertedRecord[0])")
                        
                        if entity == .book {
                            // DL thumbnail data
                            _ = InterfaceDL(id: Int((record["id"] as! NSString).doubleValue), documentType: "thumbnail")
                        }
                    }
                }
//                print("Debug : Success to save new data. [type: \(CoreDataEnumManager().toString(entity: entity))]")
            } else {
                print("Debug : New \(CoreDataEnumManager().toString(entity: entity)) does not exists.")
            }
        } else {
            status = false
        }
        
        return status
    }
}
