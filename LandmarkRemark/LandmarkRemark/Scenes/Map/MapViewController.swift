//
//  MapViewController.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 28/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift


class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let kDistanceMeters: CLLocationDistance = 500
    
    private var locationManager = CLLocationManager()
    private var userLocated = false
    private var lastAnnotation: MKAnnotation!
    private var realm: Realm!
    private var remarks = try! Realm().objects(Remark.self)
    
    
    //MARK: - Helper Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func centerToUsersLocation() {
        let center = mapView.userLocation.coordinate
        let zoomRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: kDistanceMeters, longitudinalMeters: kDistanceMeters)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func addNewPin() {
        if lastAnnotation != nil {
            let alertController = UIAlertController(title: "Annotation already dropped", message: "There is an annotation on screen. Try dragging it if you want to change its location!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive) { alert in
                alertController.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
        } else {
            let remark = RemarkAnnotation(coordinate: mapView.centerCoordinate, title: "Empty", subtitle: "Uncategorized")
            
            mapView.addAnnotation(remark)
            lastAnnotation = remark
        }
    }
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        
        locationManager.delegate = self
        navigationController?.navigationBar.barStyle = .black
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        let config = SyncUser.current?.configuration(realmURL: Constants.REALM_URL, fullSynchronization: true)
        self.realm = try! Realm(configuration: config!)
        populateMap()
    }
    
    //MARK: - Actions & Segues
    @IBAction func centerToUserLocationTappedWith(sender: AnyObject) {
        centerToUsersLocation()
    }
    
    @IBAction func addNewEntryTapped(sender: AnyObject) {
        addNewPin()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddRemark") {
            let controller = segue.destination as! AddRemarkViewController
            let remarkAnnotation = sender as! RemarkAnnotation
            controller.selectedAnnotation = remarkAnnotation
        }
    }
    
    @IBAction func unwindFromAddNewEntry(segue: UIStoryboardSegue) {
        
        let addNewEntryController = segue.source as! AddRemarkViewController
        let addedRemark = addNewEntryController.remark
        let addedRemarkCoordinate = CLLocationCoordinate2D(latitude: addedRemark!.locationLatitude, longitude: addedRemark!.locationLongitude)
        
        if let lastAnnotation = lastAnnotation {
            mapView.removeAnnotation(lastAnnotation)
        } else {
            for annotation in mapView.annotations {
                if let currentAnnotation = annotation as? RemarkAnnotation {
                    if currentAnnotation.coordinate.latitude == addedRemarkCoordinate.latitude && currentAnnotation.coordinate.longitude == addedRemarkCoordinate.longitude {
                        mapView.removeAnnotation(currentAnnotation)
                        break
                    }
                }
            }
        }
        
        
        let annotation = RemarkAnnotation(coordinate: addedRemarkCoordinate, title: addedRemark!.title , subtitle: addedRemark!.username , remark: addedRemark)
        
        mapView.addAnnotation(annotation)
        lastAnnotation = nil;
    }
    
    @IBAction func didTapLogout() {
        let alertController = UIAlertController(title: "Logout", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes, Logout",
                                                style: .destructive,
                                                handler: { [weak self]
                                                    alert -> Void in
                                                    SyncUser.current?.logOut()
                                                    self?.navigationController?.popViewController(animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func populateMap() {
        mapView.removeAnnotations(mapView.annotations)
        
        remarks = self.realm.objects(Remark.self)
        
        // Create annotations for each one
        for remark in remarks { // 3
            let coord = CLLocationCoordinate2D(latitude: remark.locationLatitude, longitude: remark.locationLongitude);
            let remarkAnnotation = RemarkAnnotation(coordinate: coord,
                                                    title: remark.title ,
                                                    subtitle: remark.username ,
                                                    remark: remark)
            mapView.addAnnotation(remarkAnnotation) // 4
        }
    }
    
}

//MARK: - CLLocationManager Delegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        status != .notDetermined ? mapView.showsUserLocation = true : print("Authorization to use location data denied")
    }
}

//MARK: - MKMapview Delegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let subtitle = annotation.subtitle! else { return nil }
        
        if (annotation is RemarkAnnotation) {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: subtitle) {
                return annotationView
            } else {
                
                let currentAnnotation = annotation as! RemarkAnnotation
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: subtitle)
                annotationView.image = UIImage(named: "pin")
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                let detailDisclosure = UIButton(type: UIButton.ButtonType.detailDisclosure)
                annotationView.rightCalloutAccessoryView = detailDisclosure
                
                if currentAnnotation.title == "Empty" {
                    annotationView.isDraggable = true
                }
                
                return annotationView
            }
        }
        return nil
        
        
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotationView in views {
            if (annotationView.annotation is RemarkAnnotation) {
                annotationView.transform = CGAffineTransform(translationX: 0, y: -500)
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
                    annotationView.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let remarkAnnotation =  view.annotation as? RemarkAnnotation {
            performSegue(withIdentifier: "AddRemark", sender: remarkAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            view.dragState = .none
        }
    }
}
