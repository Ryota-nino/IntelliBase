//
//  CoreDataEnumOperation.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/18.
//

import Foundation
import CoreData
import UIKit

struct CoreDataOperation {
    
    private let appDelegate: AppDelegate
    private let managedContext: NSManagedObjectContext
    private let coreDataEnum: CoreDataEnumManager = CoreDataEnumManager()
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func select<T:NSManagedObject>(entity: CoreDataEnumManager.EntityName, conditionStr: String = "", sort: Dictionary<String,Bool> = [:]) -> Array<T> {
        // 検索対象
        let fetchRequest: NSFetchRequest<T> = coreDataEnum.toFetchRequest(entity: entity)
        
        // 検索条件
        if conditionStr != "" {
            let predicate = NSPredicate(format: conditionStr)
            fetchRequest.predicate = predicate
        }
        // debug
//        print(conditionStr)
        
        //ソート条件指定
        var sortDescriptors: Array<NSSortDescriptor> = []
        for (columnName, asc) in sort {
            sortDescriptors.append(NSSortDescriptor(key: columnName, ascending: asc));
        }
        fetchRequest.sortDescriptors = sortDescriptors
        
        var res: Array<T> = []
        
        do{
            //検索実行
            let fetchResults: Array = try managedContext.fetch(fetchRequest)

            // 件数で場合分け
            if(fetchResults.count == 0){
                // データが0件の場合
            }else{
                res = fetchResults
            }
            
        }catch let error {
            //検索でエラーになった場合
            NSLog("\(error)")
        }
        
        return res
    }
    
    func insert(entity: CoreDataEnumManager.EntityName, values: Dictionary<String,Any>) -> Bool {
//        let entityEnum = entity
//        print("Debug : Insert values -> \(values)")
        let entity = coreDataEnum.toEntity(entity: entity, managedContext: managedContext)
        // 追加レコード
        let record = NSManagedObject(entity: entity, insertInto: self.managedContext)
        for (columnName, value) in values {
//            print("Debug : Set value -> \(columnName) : \(value) type: \(String(describing: type(of: value)))")
//            print("Debug: \(String(describing: type(of: value)) == "NSTaggedPointerString" || columnName != "login_date" && columnName.contains("_date"))")
            if String(describing: type(of: value)) == "NSTaggedPointerString" || columnName != "login_date" && columnName.contains("_date") && columnName != "update_date" && columnName != "upload_date" {
//                print("Debug : Cast on.")
                if columnName.contains("_id") || columnName == "id" || columnName.contains("_date") {
                    if String(describing: type(of: value)) == "Int" {
                        record.setValue(value, forKey: columnName)
                    } else {
                        record.setValue(Int((value as! NSString).doubleValue), forKey: columnName)
                    }
                }
            }else{
                record.setValue(value, forKey: columnName)
            }
        }
        
        var ret: Bool = true
        
        do {
            try managedContext.save()
//            print("Debug : Record Added! \(record)")
//            if entityEnum == .book {
//                for record in self.select(entity: entityEnum) {
//                    if let record: Book = record as? Book {
//                        print("Debug : Saved book id = \(String(describing: record.id!))")
//                    }
//                }
//            }
        } catch
            let error as NSError {
            print("Debug : Could not save record. \(error),\(error.userInfo)")
            ret = false
        }
        return ret
    }
    
    func delete(entity: CoreDataEnumManager.EntityName, conditionStr: String = "") -> Bool {
        let fetchRequest: NSFetchRequest<NSManagedObject> = coreDataEnum.toFetchRequest(entity: entity)
        
        // 検索条件
        if conditionStr != "" {
            fetchRequest.predicate = NSPredicate(format: conditionStr)
        }
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for record in result {
                // ノートを削除する場合に書き込みデータも削除する
                if entity == .note {
                    let request: NSFetchRequest<DrawingDoc> = DrawingDoc.fetchRequest()
                    request.includesPropertyValues = false
                    // ページ番号で昇順にソート
                    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
                    if conditionStr == "" {
                        // ノートIDで絞り込み
                        request.predicate = NSPredicate(format: "name CONTAINS %@","_note\(String(describing: (record as! Note).id!))_page")
                    }
                    do {
                        let results = try managedContext.fetch(request)
                        for item in results {
                            managedContext.delete(item)
                            try managedContext.save()
                        }
                        if let _record: Note = record as? Note {
                            // delete shared writings
                            if let _shareKey = _record.share_key {
                                _ = Interface(apiFileName: "writings/delete_shared_writings", parameter: ["share_key":_shareKey], sync: false)
                            }
                        }
                    } catch {
                        print("Error deleting document from database")
                    }
                }
                managedContext.delete(record)
            }
            try managedContext.save()
//            print("Debug : Success to delete record from \(coreDataEnum.toString(entity: entity)) having \"\(conditionStr)\"")
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    func update(entity: CoreDataEnumManager.EntityName, conditionStr: String = "", values: Dictionary<String,Any>) -> Bool {
        let fetchRequest: NSFetchRequest<NSManagedObject> = coreDataEnum.toFetchRequest(entity: entity)
        //条件指定
        if conditionStr != "" {
            fetchRequest.predicate = NSPredicate(format: conditionStr)
        }

        do {
            let result = try managedContext.fetch(fetchRequest)

            // loop fetch result
            for record in result {
                // 引数に指定された更新値をセット
                for (key, value) in values {
//                    print("Debug : Set value -> \(key) : \(value) type: \(String(describing: type(of: value)))")
//                    print("Debug : Insert value type. -> \(String(describing: type(of: value)) == "NSTaggedPointerString" || key != "login_date" && key.contains("_date"))")
                    if String(describing: type(of: value)) == "NSTaggedPointerString" || String(describing: type(of: value)) == "__NSCFString" || key == "download_date" || key == "download_thumbnail_date" {
                        record.setValue(Int(((value as! NSString) as String)), forKey: key)
                    }else{
                        record.setValue(value, forKey: key)
                    }
                }
            }
            try managedContext.save()
            print("Debug : Success to update record from \(coreDataEnum.toString(entity: entity)) having \"\(conditionStr)\". values -> \(values)")
            for record in self.select(entity: entity) {
                if let record: Book = record as? Book {
                    print("Debug : Saved book id = \(String(describing: record.id!))")
                }
            }
            return true
        } catch let error as NSError {
            print("\(error), \(error.userInfo)")
            return false
        }
    }
    
    func save() -> Bool{
        do {
            try managedContext.save()
//            print("Debug : Commit!")
            return true
        } catch
            let error as NSError {
            print("Error : Could not commit. \(error),\(error.userInfo)")
            return false
        }
    }
}
