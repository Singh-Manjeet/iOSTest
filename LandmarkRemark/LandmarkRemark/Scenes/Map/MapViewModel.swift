//
//  MapViewModel.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 30/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import RealmSwift

class MapViewModel {
    
    let kDistanceMeters: CLLocationDistance = 500
    var locationManager = CLLocationManager()
    var userLocated = false
    var lastAnnotation: MKAnnotation!
    
    init(with locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func populate(_ map: MKMapView) {
        map.removeAnnotations(map.annotations)
        
        let remarks = DataManager.sharedInstance.getRemarksFromDatabase()
        
        // Create annotations for each one
        for remark in remarks {
            let coord = CLLocationCoordinate2D(latitude: remark.locationLatitude, longitude: remark.locationLongitude)
            let remarkAnnotation = RemarkAnnotation(coordinate: coord,
                                                    title: remark.title ,
                                                    subtitle: remark.username ,
                                                    remark: remark)
            map.addAnnotation(remarkAnnotation)
        }
    }
}
