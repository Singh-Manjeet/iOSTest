//
//  MapViewController.swift
//  LandmarkRemark
//
//  Created by Manjeet Singh on 28/5/19.
//  Copyright © 2019 iOS. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift


class MapViewController: UIViewController {
    
    // MARK: - IBOutlets & Vars
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var onboardingView: UIImageView!
    
    private var locationManager = CLLocationManager()
    private var mapViewModel =  MapViewModel()
    
    var userLocation: CLLocation!
    var currentRemarkAnnotation: RemarkAnnotation?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Map"
        navigationController?.navigationBar.barStyle = .black
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        requestLocationUpdates()
        mapViewModel.populate(mapView)
        hideOnboardingIfNeeded()
    }
    
    // MARK: - Actions
    
    @IBAction func centerToUserLocationTappedWith(sender: AnyObject) {
        displayUserLocation(locationManager.location)
    }
    
    @IBAction func didTapAddNewRemark(sender: AnyObject) {
        let coordinates =  mapView.userLocation.coordinate
        userLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        currentRemarkAnnotation = nil
        Router().perform(.addRemark, from: self)
    }
    
    @IBAction func didTapViewSavedRemarks(sender: AnyObject) {
        Router().perform(.remarksList, from: self)
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
    
}

//MARK: - CLLocation Manager Delegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        status != .notDetermined ? mapView.showsUserLocation = true : print("Authorization to use location data denied")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            displayUserLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
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
                
                if currentAnnotation.title == "Please tap this landmark to give it a name." {
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
        if let annotation =  view.annotation as? RemarkAnnotation {
            currentRemarkAnnotation = annotation
            Router().perform(.addRemark, from: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            view.dragState = .none
        }
    }
}

//MARK: - Helper Funtions

private extension MapViewController {
    func requestLocationUpdates() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        locationManager.requestLocation()
    }
    
    func displayUserLocation(_ location: CLLocation?) {
        
        guard let location = location else { return }
        
        let center = location.coordinate
        let zoomRegion: MKCoordinateRegion = MKCoordinateRegion(center: center, latitudinalMeters: mapViewModel.kDistanceMeters, longitudinalMeters: mapViewModel.kDistanceMeters)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    func hideOnboardingIfNeeded() {
        
        guard !onboardingView.isHidden else { return }
        
        UIView.animateKeyframes(withDuration: 0.5,
                                delay: 3.0,
                                options: .allowUserInteraction,
                                animations: { [weak self] in
                                    
                                    guard let strongSelf = self else { return }
                                    strongSelf.onboardingView.alpha = 0
                                    
            }, completion: { [weak self] _ in
                
                guard let strongSelf = self else { return }
                strongSelf.onboardingView.isHidden = true
        })
    }
}
