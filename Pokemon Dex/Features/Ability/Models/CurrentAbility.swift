//
//  CurrentAbility.swift
//  Pokemon Dex
//
//  Created by David Giron on 25/11/25.
//

import PokemonAPI

/// A lightweight value model that groups an ability's details with the Pokémon that possess it.
struct CurrentAbility {
    /// The full `PKMAbility` model returned by the API (metadata, effects, flavor text, etc.).
    let details: PKMAbility
    /// An array of `PKMPokemon` instances that have this ability as a normal ability.
    let normalPokemons: [PKMPokemon]
    /// An array of `PKMPokemon` instances that have this ability as a hidden ability.
    let hiddenPokemons: [PKMPokemon]
}
