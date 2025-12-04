// filepath: /Users/davidgiron/Documents/Swift/5. My Projects/Pokemon Dex/Pokemon Dex/Shared/Mocks/AbilityMockFactory.swift
//
//  AbilityMockFactory.swift
//  Pokemon Dex
//
//  Created by GitHub Copilot on 03/12/25.
//

import Foundation
import PokemonAPI

enum AbilityMockFactory {
    
    // MARK: - Helper
    private static func load<T: Decodable>(_ json: String) -> T {
        let data = json.data(using: .utf8)!
        do {
            if let selfDecodableType = T.self as? any SelfDecodable.Type {
                return try selfDecodableType.decoder.decode(T.self, from: data)
            } else {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            }
        } catch {
            fatalError("AbilityMockFactory.load failed to decode JSON: \(error)\nJSON was:\n\(json)")
        }
    }
    
    // MARK: - Ability
    /// Create a minimal PKMAbility containing only id, name, generation and the first pokemon entry.
    static func mockAbility(
        id: Int,
        name: String,
        generationName: String,
        effect: String,
        shortEffect: String,
        firstPokemonName: String,
        firstPokemonIsHidden: Bool = true,
    ) -> PKMAbility {
        return load(
        """
        {
          "id": \(id),
          "name": "\(name)",
          "is_main_series": true,
          "generation": {
            "name": "\(generationName)",
            "url": "https://pokeapi.co/api/v2/generation/3/"
          },
          "effect_entries": [
             {
                  "effect": "\(effect)",
                  "language": {
                    "name": "en",
                    "url": "https://pokeapi.co/api/v2/language/9/"
                  },
                  "short_effect": "\(shortEffect)"
             }
          ], 
          "pokemon": [
            {
              "is_hidden": \(firstPokemonIsHidden),
              "pokemon": {
                "name": "\(firstPokemonName)",
                "url": "https://pokeapi.co/api/v2/pokemon/1/"
              },
              "slot": 1
            }
          ]
        }
        """
        )
    }
    
    // MARK: - Stench
    static func mockStench() -> PKMAbility {
        mockAbility(
            id: 1,
            name: "stench",
            generationName: "generation-iii",
            effect: "This Pokémon's damaging moves have a 10% chance to make the target flinch with each hit if they do not already cause flinching as a secondary effect. This ability does not stack with a held item. Overworld: The wild encounter rate is halved while this Pokémon is first in the party.",
            shortEffect: "Has a 10% chance of making target Pokémon flinch with each hit.",
            firstPokemonName: "gloom",
            firstPokemonIsHidden: true
        )
    }
}
