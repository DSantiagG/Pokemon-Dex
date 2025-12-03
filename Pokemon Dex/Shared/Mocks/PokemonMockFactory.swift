//
//  PokemonMockFactory.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//

import Foundation
import PokemonAPI

enum PokemonMockFactory {
    
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
            fatalError("PokemonMockFactory.load failed to decode JSON: \(error)\nJSON was:\n\(json)")
        }
    }
    
    // MARK: - Types
    static func mockType(name: String) -> PKMPokemonType {
        load("""
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
    static func mockStat(name: String, baseStat: Int) -> PKMPokemonStat {
        load("""
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
    static func mockAbility(name: String, isHidden: Bool) -> PKMPokemonAbility {
        load("""
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
        
        return load("""
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
