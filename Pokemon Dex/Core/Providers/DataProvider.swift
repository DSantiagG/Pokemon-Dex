//
//  DataProvider.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//


import Foundation
import Combine

@MainActor
class DataProvider: ObservableObject {
    let pokemonViewModel = PokemonViewModel()
    //@Published var abilityViewModel = AbilityViewModel()
    //@Published var berryViewModel = BerryViewModel()
    //@Published var locationViewModel = LocationViewModel()
}
