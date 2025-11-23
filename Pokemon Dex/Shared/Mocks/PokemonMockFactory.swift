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
        
        if let selfDecodableType = T.self as? any SelfDecodable.Type {
            return try! selfDecodableType.decoder.decode(T.self, from: data)
        } else {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try! decoder.decode(T.self, from: data)
        }
    }
    
    // MARK: - Types
    static func mockType(
        slot: Int = 1,
        name: String = "grass",
        url: String = "https://pokeapi.co/api/v2/type/12/"
    ) -> PKMPokemonType {
        load("""
        {
            "slot": \(slot),
            "type": {
                "name": "\(name)",
                "url": "\(url)"
            }
        }
        """)
    }
    
    // MARK: - Stats
    static func mockStat(
        name: String = "hp",
        baseStat: Int = 45,
        url: String = "https://pokeapi.co/api/v2/stat/1/"
    ) -> PKMPokemonStat {
        load("""
        {
            "base_stat": \(baseStat),
            "effort": 0,
            "stat": {
                "name": "\(name)",
                "url": "\(url)"
            }
        }
        """)
    }
    
    // MARK: - Ability
    static func mockAbility(
        name: String = "overgrow",
        isHidden: Bool = false,
        url: String = "https://pokeapi.co/api/v2/ability/65/",
        slot: Int = 1
    ) -> PKMPokemonAbility {
        load("""
        {
            "ability": {
                "name": "\(name)",
                "url": "\(url)"
            },
            "is_hidden": \(isHidden),
            "slot": \(slot)
        }
        """)
    }
    
    // MARK: - Species
    static func mockSpecies(flavor: String) -> PKMPokemonSpecies {
        load("""
        {
            "flavor_text_entries": [
                {
                    "flavor_text": "\(flavor)",
                    "language": { "name": "en", "url": "" },
                    "version": { "name": "red", "url": "" }
                }
            ],
            "evolution_chain": {
                "url": "https://pokeapi.co/api/v2/evolution-chain/1/"
            }
        }
        """)
    }
    
    // MARK: - Pokémon base (sin sprites)
    static func mockPokemonBase(
        id: Int,
        name: String,
        types: [PKMPokemonType]
    ) -> PKMPokemon {
        
        let typesJSON = types
            .map { """
            {"slot": \($0.slot ?? 1), "type": {"name": "\($0.type?.name ?? "grass")", "url": "\($0.type?.url ?? "")"}}
            """ }
            .joined(separator: ",")
        
        return load("""
        {
            "id": \(id),
            "name": "\(name)",
            "height": 7,
            "weight": 69,
            "types": [\(typesJSON)],
            "abilities": [],
            "stats": []
        }
        """)
    }
    
    // MARK: - Pokémon completo (Bulbasaur)
    static func mockBulbasaur() -> PKMPokemon {
        mockPokemonBase(
            id: 1,
            name: "bulbasaur",
            types: [
                mockType(name: "grass"),
                mockType(name: "poison")
            ]
        )
    }
    
    // MARK: - Evolution Chain (3 stages)
    static func mockStageEvolution(
        name: String = "bulbasaur",
        sprite: String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
    ) -> EvolutionStage {
        return EvolutionStage(name: name, sprite: sprite)
    }
}
