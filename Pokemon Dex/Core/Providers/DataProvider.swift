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

    static let shared = DataProvider()

    let pokemonService: PokemonService
    let abilityService: AbilityService
    let itemService: ItemService

    private init() {
        self.pokemonService = PokemonService()
        self.abilityService = AbilityService()
        self.itemService = ItemService()
    }
}
