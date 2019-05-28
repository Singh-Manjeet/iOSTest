//
//  Remark.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 28/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import RealmSwift

class Remark: Object {
    
    @objc dynamic var remarkId: String = UUID().uuidString
    @objc dynamic var username: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var detail: String = ""
    @objc dynamic var locationLatitude: Double = 0.0
    @objc dynamic var locationLongitude: Double = 0.0
    @objc dynamic var addedDate: Date = Date()
    
    override static func primaryKey() -> String? {
        return "remarkId"
    }
}
