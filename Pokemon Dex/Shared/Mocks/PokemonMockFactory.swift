//
//  PokemonMockFactory.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//

import Foundation
import PokemonAPI

/// Factory helpers to create minimal `PKMPokemon`-related model instances for previews and tests.
///
/// These functions use `MockFactory.decode(_:)` to produce concrete model objects from
/// inline JSON snippets so previews don't rely on network responses.
enum PokemonMockFactory {
    
    // MARK: - Types
    /// Create a minimal `PKMPokemonType` resource with the supplied name.
    ///
    /// - Parameter name: The type name (e.g. "grass").
    /// - Returns: A decoded `PKMPokemonType`.
    static func mockType(name: String) -> PKMPokemonType {
        MockFactory.decode("""
        {
            "slot": 1,
            "type": {
                "name": "\(name)",
                "url": ""
            }
        }
        """)
    }
    
    // MARK: - Stats
    /// Create a minimal `PKMPokemonStat` with the provided base value.
    ///
    /// - Parameters:
    ///   - name: Stat identifier (e.g. "hp").
    ///   - baseStat: The base stat number.
    /// - Returns: A decoded `PKMPokemonStat`.
    static func mockStat(name: String, baseStat: Int) -> PKMPokemonStat {
        MockFactory.decode("""
        {
            "base_stat": \(baseStat),
            "effort": 0,
            "stat": {
                "name": "\(name)",
                "url": ""
            }
        }
        """)
    }
    
    // MARK: - Ability
    /// Create a minimal `PKMPokemonAbility` entry.
    ///
    /// - Parameters:
    ///   - name: Ability slug.
    ///   - isHidden: Whether the ability entry is hidden.
    /// - Returns: A decoded `PKMPokemonAbility`.
    static func mockAbility(name: String, isHidden: Bool) -> PKMPokemonAbility {
        MockFactory.decode("""
        {
            "ability": {
                "name": "\(name)",
                "url": ""
            },
            "is_hidden": \(isHidden),
            "slot": 1
        }
        """)
    }
    
    // MARK: - Pokémon
    /// Create a minimal `PKMPokemon` with the supplied characteristics.
    ///
    /// - Parameters:
    ///   - id: Numeric Pokémon id.
    ///   - order: Display order number.
    ///   - name: Pokémon slug.
    ///   - sprite: URL string to the official artwork sprite.
    ///   - abilities: Optional array of `PKMPokemonAbility` entries.
    ///   - types: Optional array of `PKMPokemonType` entries.
    ///   - stats: Optional array of `PKMPokemonStat` entries.
    /// - Returns: A decoded `PKMPokemon` instance suitable for previews.
    static func mockPokemon(
        id: Int,
        order: Int,
        name: String,
        sprite: String,
        abilities: [PKMPokemonAbility] = [],
        types: [PKMPokemonType] = [],
        stats: [PKMPokemonStat] = []
    ) -> PKMPokemon {
        
        let abilitiesJSON = abilities
            .map { """
                    {"ability": {"name": "\($0.ability?.name ?? "")","url": ""},
                    "is_hidden": \($0.isHidden ?? false),
                    "slot": 1}
                """}
            .joined(separator: ",")
        
        let typesJSON = types
            .map { """
                    {"slot": 1, 
                    "type": {"name": "\($0.type?.name ?? "grass")", 
                    "url": ""}}
                """ }
            .joined(separator: ",")
        
        let statsJSON = stats
            .map { """
                    {"base_stat": \($0.baseStat ?? 0),
                    "effort": 0,
                    "stat": {"name": "\($0.stat?.name ?? "")","url": ""}
                    }
                """}
            .joined(separator: ",")
        
        return MockFactory.decode("""
        {
            "id": \(id),
            "order": \(order),
            "name": "\(name)",
            "abilities": [\(abilitiesJSON)],
            "types": [\(typesJSON)],
            "stats": [\(statsJSON)],
            "sprites": {
                "other": {
                    "official-artwork": {"front_default": "\(sprite)"}
                }
            },
            "cries": {
                "latest": "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/132.ogg"
            },
            "past_types": [],
            "past_abilities": []
        }
        """)
    }
    
    // MARK: - Pokémon (Bulbasaur)
    /// Convenience mock for Bulbasaur with typical stats, types and abilities.
    ///
    /// - Returns: A `PKMPokemon` representing Bulbasaur.
    static func mockBulbasaur() -> PKMPokemon {
        mockPokemon(
            id: 1,
            order: 1,
            name: "bulbasaur",
            sprite: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
            abilities: [
                mockAbility(name: "overgrow", isHidden: false),
                mockAbility(name: "chlorophyll", isHidden: true)
            ],
            types: [
                mockType(name: "grass"),
                mockType(name: "poison")
            ],
            stats: [
                mockStat(name: "hp", baseStat: 45),
                mockStat(name: "attack", baseStat: 49),
                mockStat(name: "defense", baseStat: 49),
                mockStat(name: "special-attack", baseStat: 65),
                mockStat(name: "special-defense", baseStat: 65),
                mockStat(name: "speed", baseStat: 45)
            ]
        )
    }
}
