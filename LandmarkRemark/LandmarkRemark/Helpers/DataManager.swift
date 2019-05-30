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
    
    private var database: Realm
    
    // MARK: - Singleton
    static let sharedInstance = DataManager()
    
    private init() {
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        database = try! Realm(configuration: config!)
    }
    
    // MARK: - Public functions
    
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
    
    func deleteFromDatabase(object: Remark)   {
        try! database.write {
            database.delete(object)
        }
    }
}
