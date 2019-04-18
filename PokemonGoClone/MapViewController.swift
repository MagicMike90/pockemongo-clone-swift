//
//  MapViewController.swift
//  PokemonGoClone
//
//  Created by Michael Luo on 18/4/19.
//  Copyright © 2019 Michael Luo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var updateCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            // Setup
            setup()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // Setup
            setup()
        }
    }
    
    func setup() {
        mapView.showsUserLocation = true;
        manager.startUpdatingLocation();
        mapView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if updateCount < 3 {
            
            if let center = manager.location?.coordinate
            {
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200);
                mapView.setRegion(region, animated: false)
            }
            
            updateCount += 1;
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if let center = manager.location?.coordinate
            {
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200);
                mapView.setRegion(region, animated: true)
            }
        }
    }
    
}
