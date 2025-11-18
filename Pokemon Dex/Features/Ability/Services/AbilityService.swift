//
//  AbilityService.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import PokemonAPI

actor AbilityService {
    private let api = PokemonAPI()
    
    private var abilityCache = [String: PKMAbility]()
    
    func fetchAbility(name: String) async throws -> PKMAbility {
        if let cached = abilityCache[name] {
            print("Retornando de cache de ability: \(name)")
            return cached
        }
        let ability = try await api.pokemonService.fetchAbility(name)
        abilityCache[name] = ability
        return ability
    }
}
