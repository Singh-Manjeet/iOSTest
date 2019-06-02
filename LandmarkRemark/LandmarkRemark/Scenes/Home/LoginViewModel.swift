//
//  HomeViewModel.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 29/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation
import RealmSwift

enum LoginState {
    case error
    case alreadyloggedIn
    case newUser
}

class LoginViewModel {
    
    func login(username: String?, onCompletion: @escaping (_ state: LoginState) -> Void) {
        
        guard let username = username else {
            onCompletion(.error)
            return
        }
        
        if let _ = SyncUser.current {
            onCompletion(.alreadyloggedIn)
        } else {
            let creds = SyncCredentials.nickname(username, isAdmin: true)
            
            SyncUser.logIn(with: creds, server: Constants.AUTH_URL,
                           onCompletion: { (user, err) in
                            if let _ = user {
                                DataManager.sharedInstance.saveUserName(username)
                                onCompletion(.newUser)
                            } else if let _ = err {
                                onCompletion(.error)
                            }
            })
        }
    }
}
