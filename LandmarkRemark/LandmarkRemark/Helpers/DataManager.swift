//
//  DataManager.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 30/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import RealmSwift

class DataManager {
    
    // MARK: - Vars
    
    typealias deletionBlock = ((_ isDeleted: Bool)->Void)?
    var database: Realm
   
    var userName: String {
        return UserDefaults.standard.value(forKey: Constants.Keys.username) as! String
    }
   
    // MARK: - Singleton
    static let sharedInstance = DataManager()
    
    private init() {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        database = try! Realm(configuration: config!)
    }
    
    // MARK: - Public Functions
    
    func getRemarksFromDatabase() ->   Results<Remark> {
        let results: Results<Remark> = database.objects(Remark.self)
        return results
    }
    
    func addRemark(object: Remark)   {
        try! database.write {
            database.add(object, update: true)
            print("Added new remark")
        }
    }
    
    func truncateDatabase()  {
        try! database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDatabase(object: Remark, isSuccessful: deletionBlock = nil) {
       
        guard canDelete(object) else {
            if let isSuccessfulBlock = isSuccessful {
                return isSuccessfulBlock(false)
            }
            return
        }
        
        try! database.write {
            database.delete(object)
            if let isSuccessfulBlock = isSuccessful {
                return isSuccessfulBlock(true)
            }
        }
    }
    
    func saveUserName(_ username: String) {
        UserDefaults.standard.set(username, forKey: Constants.Keys.username)
        UserDefaults.standard.synchronize()
    }
    
    func canDelete(_ remark: Remark) -> Bool {
        guard userName == remark.username else { return false }
        return true
    }
}
