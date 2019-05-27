//
//  Constants.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 27/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation
struct Constants {
    static let MY_INSTANCE_ADDRESS = "test-ios.us1.cloud.realm.io"
    static let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
    static let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/ToDo")!
}
