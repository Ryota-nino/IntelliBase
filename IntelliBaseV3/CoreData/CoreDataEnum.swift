//
//  CoreDataEnum.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/18.
//

import Foundation
import CoreData

struct CoreDataEnumManager {
    
    enum EntityName {
        case account
        case author
        case book
        case genre
        case note
        case purchase
        case drawingDoc
    }
    
    var entityName: String = "Book"
    
    func toString(entity: EntityName) -> String {
        switch entity {
            case .account:
                return "Account"
            case .author:
                return "Author"
            case .book:
                return "Book"
            case .genre:
                return "Genre"
            case .note:
                return "Note"
            case .purchase:
                return "Purchase"
            case .drawingDoc:
                return "DrawingDoc"
        }
    }
    
    func toEntity(entity: EntityName, managedContext: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: self.toString(entity: entity), in : managedContext)!
    }
    
    func toFetchRequest<T>(entity: EntityName) -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: self.toString(entity: entity))
    }
}
