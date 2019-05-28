//
//  StoryboardIdentifiable.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 29/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}
