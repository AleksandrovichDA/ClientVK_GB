//
//  AddLocationController.swift
//  L1_AleksandrovichDenis
//
//  Created by Denis on 16.11.2017.
//  Copyright © 2017 GBSWIFT. All rights reserved.
//

import UIKit
import MapKit

class AddLocationController: UIViewController {

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
            presenter.textPost.text = oldText + "Локация: " + country + ", " + administrativeArea + ", " + subLocality + ", " + thoroughfare + ", " + subThoroughfare
        }
        
        self.dismiss(animated: true, completion: nil)
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

