//
//  Launcher.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 27/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

class Launcher {
    
    // MARK: - Static methods
    static func launch(with window: UIWindow?) {
        if let navigationController = window?.rootViewController as? UINavigationController,
            let _ = navigationController.viewControllers.first as? LoginViewController {
        }
    }
}

