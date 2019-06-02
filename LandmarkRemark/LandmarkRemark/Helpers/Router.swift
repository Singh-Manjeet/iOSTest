//
//  Router.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 28/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import RealmSwift

enum RouterSegue {
    case map
    case addRemark
    case viewRemark
    case remarksList
}

protocol Routing {
    func perform(_ segue: RouterSegue, from source: UIViewController)
}

// MARK: - A Common place to navigate in between the app

class Router: Routing {
    
    func perform(_ segue: RouterSegue, from source: UIViewController) {
        var destinationViewController: UIViewController!
        
        switch segue {
        case .map:
            destinationViewController = Router.makeMapViewController()
            source.navigationController?.pushViewController(destinationViewController, animated: true)
        case .remarksList:
            destinationViewController = Router.makeRemarksListViewController()
            source.navigationController?.pushViewController(destinationViewController, animated: true)
        case .addRemark, .viewRemark:
            let destination = Router.makeAddRemarkViewController()
            if let mapViewController = source as? MapViewController {
                destination.selectedAnnotation = mapViewController.currentRemarkAnnotation == nil ? RemarkAnnotation(coordinate: mapViewController.userLocation.coordinate) : mapViewController.currentRemarkAnnotation!
                source.navigationController?.pushViewController(destination, animated: true)
            }
            
        }
    }
}

// MARK: - Helper Functions

private extension Router {
    
    static func makeMapViewController() -> MapViewController {
        return UIStoryboard(storyboard: .map).instantiateViewController()
    }
    
    static func makeRemarksListViewController() -> RemarksListViewController {
        return UIStoryboard(storyboard: .remarks).instantiateViewController()
    }
    
    static func makeAddRemarkViewController() -> AddRemarkViewController {
        return UIStoryboard(storyboard: .remark).instantiateViewController()
    }
}

