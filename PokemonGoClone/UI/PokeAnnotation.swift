//
//  PokeAnnotation.swift
//  PokemonGoClone
//
//  Created by Michael Luo on 22/4/19.
//  Copyright © 2019 Michael Luo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PokeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coord:CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
