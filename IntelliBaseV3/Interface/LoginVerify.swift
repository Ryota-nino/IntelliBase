//
//  LoginVerify.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import Foundation

struct LoginVerify {
    var verify: Bool = false
    var error: Bool
    var processing: Bool = true
    var id: Int
    
    init(email: String, password: String) {
        let interface = Interface(apiFileName: "verify_pass", parameter: ["email": email, "pass": password], sync: true)
        while interface.isDownloading {}
        self.error = interface.error
        
        print(interface.content)
        
        if !interface.error || interface.content.count != 0 {
            
            self.verify = interface.content[0]["verify"] as! Bool
            
            if verify {
                self.id = Int((interface.content[0]["id"] as! NSString).doubleValue)
                let name: String = interface.content[0]["name"] as! String
                let coreData = CoreDataOperation()
                let entity: CoreDataEnumManager.EntityName = .account
                // already login this app?
                if coreData.select(entity: entity, conditionStr: "id = \(id)").count != 0 {
                    // update coreData
                    if !coreData.update(entity: entity, conditionStr: "id = \(id)", values: ["login":true, "login_date":Date()]) {
                        // Error at update coreData.
                        print("Error : Error at update coreData entity \"Account\".")
                    }
                } else {
                    // insert new accout to coreData.
                    if !coreData.insert(entity: entity, values: ["id":id, "email":email, "name":name, "login":true, "login_date":Date()]) {
                        // Error
                        print("Error : Error at insert coreData entity \"Account\".")
                    }
                }
            } else {
                self.id = 0
            }
        } else {
            self.id = 0
        }
        
        self.processing = false
        
        return
    }
}
