//
//  WelcomeViewController.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 27/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {
    
    //MARK: - View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        title = "Welcome"
        
        if let _ = SyncUser.current {
            // We have already logged in user
        
        } else {
            let alertController = UIAlertController(title: "Greetings !!", message: "Please enter the username", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Proceed",
                                                    style: .default,
                                                    handler: { [unowned self]
                alert -> Void in
                let textField = alertController.textFields![0] as UITextField
                let creds = SyncCredentials.nickname(textField.text!, isAdmin: true)
                
                SyncUser.logIn(with: creds,
                               server: Constants.AUTH_URL,
                               onCompletion: { [weak self](user, err) in
                    if let _ = user {
                        // will navigate to map screen
                        // starting day 2
                    } else if let error = err {
                        fatalError(error.localizedDescription)
                    }
                })
            }))
        
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "Username"
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


