//
//  Router.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 28/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

enum RouterSegue {
    case map
    case addRemark
}

protocol Routing {
    func perform(_ segue: RouterSegue, from source: UIViewController)
}

class Router: Routing {
    
    func perform(_ segue: RouterSegue, from source: UIViewController) {
        var destinationViewController: UIViewController!
        switch segue {
        case .map:
            destinationViewController = Router.makeMapViewController()
        case .addRemark:
            destinationViewController = Router.makeAddRemarkViewController()
        }
        
        source.navigationController?.pushViewController(destinationViewController, animated: true)
    }
}

// MARK: Helpers

private extension Router {
    
    static func makeMapViewController() -> MapViewController {
        return UIStoryboard(storyboard: .map).instantiateViewController()
    }
    
    static func makeAddRemarkViewController() -> AddRemarkViewController {
       return UIStoryboard(storyboard: .addRemark).instantiateViewController()
    }
}

