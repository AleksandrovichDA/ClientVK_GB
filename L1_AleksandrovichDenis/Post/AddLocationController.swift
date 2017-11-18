//
//  AddLocationController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 16.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddLocationController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManger.instance.delegete = self
        LocationManger.instance.startUpdateLocation()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocation(_ sender: Any) {
        
        if let presenter = presentingViewController as? PostViewController {
            let administrativeArea = LocationManger.instance.location?.administrativeArea ?? ""
            let country = LocationManger.instance.location?.country ?? ""
            let subLocality = LocationManger.instance.location?.subLocality ?? ""
            let thoroughfare = LocationManger.instance.location?.thoroughfare ?? ""
            let subThoroughfare = LocationManger.instance.location?.subThoroughfare ?? ""
            let oldText = presenter.textPost.text ?? ""
            presenter.textPost.text = oldText + "Локация: " + country + "\n" + administrativeArea + "\n" + subLocality + "\n" + thoroughfare + ", " + subThoroughfare
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {
        let geocoder = CLGeocoder()
        var placeMark: CLPlacemark?
        let newLocationPin = sender.location(in: self.mapView)
        let newCoordinate = self.mapView.convert(newLocationPin, toCoordinateFrom: self.mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinate
        annotation.title = "Новая позиция"
        
        let newLocation: CLLocation =  CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
        
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: { (placemarks, error) -> Void in
            placeMark = placemarks?[0]
            let administrativeArea = placeMark?.administrativeArea
            let country = placeMark?.country
            let subLocality = placeMark?.subLocality
            let thoroughfare = placeMark?.thoroughfare
            let subThoroughfare = placeMark?.subThoroughfare
            annotation.subtitle = country! + "\n" + administrativeArea! + "\n" + subLocality! + "\n" + thoroughfare! + ", " + subThoroughfare!
            LocationManger.instance.location = placeMark
        })

        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotation(annotation)
    }
}

extension AddLocationController: LocationMangerDelegate {
    func locationManger(_ locationManger: LocationManger, coordination: CLLocationCoordinate2D) {
        let currentRadius: CLLocationDistance = 500
        let currentRegion = MKCoordinateRegionMakeWithDistance((coordination), currentRadius * 2.0, currentRadius * 2.0)
        mapView.setRegion(currentRegion, animated: true)
        mapView.showsUserLocation = true
    }
}

