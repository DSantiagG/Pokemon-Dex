//
//  CurrentAbility.swift
//  Pokemon Dex
//
//  Created by David Giron on 25/11/25.
//

import PokemonAPI

/// A lightweight value model that groups an ability's details with the Pokémon that possess it.
/// - Parameters:
///    - details: The full `PKMAbility` model returned by the API (metadata, effects, flavor text, etc.).
///    - normalPokemons: An array of `PKMPokemon` instances that have this ability as a normal ability.
///    - hiddenPokemons: An array of `PKMPokemon` instances that have this ability as a hidden ability.
struct CurrentAbility {
    let details: PKMAbility
    let normalPokemons: [PKMPokemon]
    let hiddenPokemons: [PKMPokemon]
}
