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
    var pokemons = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deletePokemons()
        
        pokemons = getAllPokemons()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
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
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate
            {
                var annoCoord = center
                annoCoord.latitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                annoCoord.longitude += (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                let randomPokemon = self.pokemons[randomIndex]
                
                let anno = PokeAnnotation(coord: annoCoord, pokemon: randomPokemon)
                self.mapView.addAnnotation(anno);
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // reinitialize selection
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation {
            // This is the user
            centerTapped("Hello")
        } else {
            if let center = manager.location?.coordinate {
                if let pokemonCenter =  view.annotation?.coordinate {
                    let region = MKCoordinateRegion(center: pokemonCenter, latitudinalMeters: 200, longitudinalMeters: 200)
                    
                    if let pokemonAnnotaion = view.annotation as? PokeAnnotation {
                        mapView.setRegion(region, animated: true)
                        if let pokeName = pokemonAnnotaion.pokemon.name {
                            // check if the user location is inside the visible map view
                            if mapView.visibleMapRect.contains( MKMapPoint.init(center)) {
                                pokemonAnnotaion.pokemon.caught =  true
                                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                                
                                let alerveVC = UIAlertController(title: "Congrats", message: "You caught a \(pokeName)", preferredStyle: .alert)
                                let pokedexAtion =  UIAlertAction(title: "Pokedex", style: .default) { (action) in
                                    self.performSegue(withIdentifier: "moveToPokedex", sender: nil)
                                }
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    alerveVC.dismiss(animated: true, completion: nil)
                                }
                                alerveVC.addAction(pokedexAtion)
                                alerveVC.addAction(okAction)
                                present(alerveVC,animated: true, completion: nil)
                                
                            } else {
                                let alerveVC = UIAlertController(title: "Oops", message: "You are too far away from this \(pokeName) to catch it. Try monving closer!", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    alerveVC.dismiss(animated: true, completion: nil)
                                }
                                alerveVC.addAction(okAction)
                                present(alerveVC,animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            // Show the trainer
            annoView.image =  UIImage(named: "player")
        } else {
            if let pokeAnnotation =  annotation as? PokeAnnotation {
                if let imageName = pokeAnnotation.pokemon.imageName {
                    annoView.image =  UIImage(named: imageName)
                }
            }
        }
        
        var frame = annoView.frame
        frame.size.height = 40
        frame.size.width = 40
        annoView.frame = frame
        
        return annoView
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
