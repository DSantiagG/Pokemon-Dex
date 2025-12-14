//
//  ItemMockFactory.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import Foundation
import PokemonAPI

enum ItemMockFactory {
    
    // MARK: - Atribute
    static func mockAtribute(name: String) -> PKMAPIResource<PKMItemAttribute> {
        MockFactory.decode("""
        {
            "name": "\(name)",
            "url": "https://pokeapi.co/api/v2/item-attribute/1/"
        }
        """)
    }
    
    // MARK: - Item
    /// Create a minimal PKMItem
    static func mockItem(
        id: Int,
        name: String,
        cost: Int,
        category: String,
        effect: String,
        shortEffect: String,
        sprites: String,
        atributes: [PKMAPIResource<PKMItemAttribute>]
    ) -> PKMItem {
        
        let atributesJSON = atributes
            .map { """
                    {"name": "\($0.name ?? "countable")", 
                    "url": "\($0.url ?? "")"}
                """ }
            .joined(separator: ",")
        
        return MockFactory.decode(
        """
        {
          "id": \(id),
          "name": "\(name)",
          "cost": \(cost),
          "attributes": [\(atributesJSON)],
          "category": {
            "name": "\(category)",
            "url": "https://pokeapi.co/api/v2/item-category/1/"
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
          "sprites": {
             "default": "\(sprites)"
          }
        }
        """
        )
    }
    
    static func mockMasterBall() -> PKMItem {
        mockItem(
            id: 1,
            name: "master-ball",
            cost: 0,
            category: "standard-balls",
            effect: "Used in battle: Catches a wild Pokémon without fail. If used in a trainer battle, nothing happens and the ball is lost.",
            shortEffect: "Catches a wild Pokémon every time.",
            sprites: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/master-ball.png",
            atributes: [
                mockAtribute(name: "countable"),
                mockAtribute(name: "consumable"),
                mockAtribute(name: "usable-in-battle"),
                mockAtribute(name: "holdable")
            ])
    }
}
