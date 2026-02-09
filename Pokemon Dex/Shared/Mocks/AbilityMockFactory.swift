// filepath: /Users/davidgiron/Documents/Swift/5. My Projects/Pokemon Dex/Pokemon Dex/Shared/Mocks/AbilityMockFactory.swift
//
//  AbilityMockFactory.swift
//  Pokemon Dex
//
//  Created by GitHub Copilot on 03/12/25.
//

import Foundation
import PokemonAPI

/// Factory helpers for creating minimal `PKMAbility` test objects.
///
/// Use these helpers in previews and unit tests to produce small, predictable
/// `PKMAbility` instances without performing network calls.
enum AbilityMockFactory {
    
    // MARK: - Ability
    /// Create a minimal `PKMAbility` instance from the provided fields.
    ///
    /// - Parameters:
    ///   - id: Numeric ability identifier.
    ///   - name: Ability slug (e.g. "stench").
    ///   - generationName: Generation resource name (e.g. "generation-iii").
    ///   - effect: Full effect text shown in the ability detail.
    ///   - shortEffect: Short effect summary.
    ///   - firstPokemonName: Name of the first Pokémon entry in the ability's `pokemon` array.
    ///   - firstPokemonIsHidden: Whether the first Pokémon entry is a hidden ability.
    /// - Returns: A decoded `PKMAbility` populated with the minimal JSON above.
    static func mockAbility(
        id: Int,
        name: String,
        generationName: String,
        effect: String,
        shortEffect: String,
        firstPokemonName: String,
        firstPokemonIsHidden: Bool = true,
    ) -> PKMAbility {
        return MockFactory.decode(
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
    /// Convenience mock for the classic `stench` ability.
    ///
    /// - Returns: A `PKMAbility` representing the `stench` ability with a single example Pokémon.
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
