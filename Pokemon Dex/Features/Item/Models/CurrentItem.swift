//
//  CurrentItem.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import PokemonAPI

/// Container with an item and its related holding Pokémon.
/// - Properties:
///   - `details`: The item details model.
///   - `holdingPokemon`: Pokémon that commonly hold this item.
struct CurrentItem {

    let details: PKMItem
    let holdingPokemon: [PKMPokemon]
}
