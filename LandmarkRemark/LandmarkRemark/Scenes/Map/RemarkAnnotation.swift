//
//  RemarkAnnotation.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 28/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import MapKit

class RemarkAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var remark: Remark?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, remark: Remark? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.remark = remark
    }
    
    
}

