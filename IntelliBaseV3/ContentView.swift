//
//  ContentView.swift
//  IntelliBaseV2
//
//  Created by てぃん on 2020/12/15.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var navigation: Bool = false
    @State var id: Int = 0
    @State var email: String = ""
    @State var loginSkip: Bool = false
    
    init() {
        // init coreData (debug)
//        let coreData = CoreDataOperation()
        
        // delete datas in coreData
//        _ = coreData.delete(entity: .book)
//        _ = coreData.delete(entity: .purchase)
//        _ = coreData.delete(entity: .author)
//        _ = coreData.delete(entity: .genre)
//        _ = coreData.delete(entity: .note)
//        _ = coreData.delete(entity: .account)
        
        // commit
//        _ = coreData.save()
        
        // log to check saved data.
//        print("Debug : Saved accounts.")
//        for account: Account in coreData.select(entity: .account) {
//            print([
//                "id":account.id!,
//                "email":account.email!,
//                "name":account.name!,
//                "login":account.login
//            ])
//        }
//        print("Debug : Saved purchase infomations.")
//        for purchase: Purchase in coreData.select(entity: .purchase) {
//            print([
//                "id":purchase.id!,
//                "account":purchase.account_id!,
//                "book":purchase.book_id!
//            ])
//        }
//        print("Debug : Saved books.")
//        for book: Book in coreData.select(entity: .book) {
//            print([
//                "id":book.id!,
//                "title":book.title!,
//                "author":book.author_id!,
//                "genre":book.genre_id!,
//                "dl":book.download_date!
//            ])
//        }
//        print("Debug : Seved authors.")
//        for author:Author in coreData.select(entity: .author) {
//            print([
//                "id":author.id!,
//                "name":author.name!
//            ])
//        }
//        print("Debug : Saved genres.")
//        for genre: Genre in coreData.select(entity: .genre) {
//            print([
//                "id":genre.id!,
//                "name":genre.name!,
//                "parent":genre.parent_id!
//            ])
//        }
//        print("Debug : Saved notes.")
//        for note: Note in coreData.select(entity: .note) {
//            print([
//                "id":note.id!,
//                "book":note.book_id!,
//                "title":note.title!,
//                "account":note.account_id!,
//                "update":note.update_date!
//            ])
//        }
    }
    
    var body: some View {
        NavigationView {
            NavigationLink(
                destination:
                    LoginView(email: email, id: id, skipLogin: loginSkip)
                    .navigationBarHidden(true),
                isActive:
                    $navigation
            ){
                Text("Login")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
            let coreData = CoreDataOperation()
            
            // get genres from api.
            var entity: CoreDataEnumManager.EntityName = .genre
            let dataGetter = GetNewData()
            _ = dataGetter.download(entity: entity)
            // wait download
            while dataGetter.interface!.isDownloading {}
            
            entity = .account
            
            // Used acocunt exist ?
            if coreData.select(entity: entity).count > 0 {
                // Loginned ?
                // Get loginned account.
                let loginnedAccountAry: Array<Account> = coreData.select(entity: entity, conditionStr: "login == true")
                if loginnedAccountAry.count == 1 {
                    // loginned account
                    let loginnedAccount: Account = loginnedAccountAry[0]
                    
                    // account id
                    self.id = loginnedAccount.id as! Int
                    
                    // loginned date
                    let date: Date = loginnedAccount.login_date!
                    
                    // formatted loginned date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMddHHmmss"
                    dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
                    let dateInt: Int = Int(dateFormatter.string(from: date))!
                    
                    // Check password update.
                    let interface = Interface(apiFileName: "get_modify_date", parameter: ["id":"\(id)", "type":"password"], sync: true)
                    while interface.isDownloading {}
                    
                    var modifiedDateInt: Int = 0
                    for row in interface.content {
                        if let datetime: Int = row["datetime"] as? Int {
                            modifiedDateInt = datetime
                        }
                    }
                    
                    if dateInt < modifiedDateInt {
                        // Loginned account's password modified.
                        
                        // Account: login <- false
                        if coreData.update(entity: entity, conditionStr: "id == \(id)", values: ["login":false]) {}
                        
                        // Navigation login view.
//                        print("Debug : Loginned account's password modified. id : \(id)")
                        self.navigation = true
                    } else {
                        // Navigation menu with skip login view.
//                        print("Debug : Skip login. id : \(id)")
                        self.loginSkip = true
                        self.navigation = true
                    }
                } else {
                    // Get most recently used account.
                    let account: Account = coreData.select(entity: entity, conditionStr: "", sort: ["login_date":false])[0]
                    self.email = account.email!
                    
                    // No logining accout.
//                    print("Debug : Navigation login view with email client has ever loginned.")
                    self.navigation = true
                }
            } else {
                // Client has never loginned.
//                print("Debug : First try to login.")
                self.navigation = true
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
