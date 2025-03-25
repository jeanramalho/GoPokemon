//
//  PokemonAnnotation.swift
//  GoPokemon
//
//  Created by Jean Ramalho on 25/03/25.
//
import UIKit
import Foundation
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemons
    
    init(coordenadas: CLLocationCoordinate2D, pokemon: Pokemons) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
}
