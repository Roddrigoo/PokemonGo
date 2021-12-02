//
//  PokemonAnnotation.swift
//  PokemonGo
//
//  Created by Rodrigo Lourenço on 27/10/21.
//

import UIKit
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(local: CLLocationCoordinate2D, pokemon: Pokemon){
        self.coordinate = local
        self.pokemon = pokemon
    }
}
