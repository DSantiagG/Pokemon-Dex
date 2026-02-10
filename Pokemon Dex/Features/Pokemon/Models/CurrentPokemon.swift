//
//  CurrentPokemon.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import PokemonAPI

/// Presentation model aggregating a Pokémon's detailed data and related entities.
///
/// Use `CurrentPokemon` as a lightweight container in detail screens to hold
/// the fetched `PKMPokemon` plus resolved abilities, species, evolution stages,
/// alternate forms and held items.
///
/// - Parameters:
///    - details: The primary `PKMPokemon` model.
///    - normalAbilities: Abilities available in normal slots.
///    - hiddenAbilities: Abilities marked as hidden for this Pokémon.
///    - species: The `PKMPokemonSpecies` resource for additional metadata.
///    - evolution: Array of `EvolutionStage` representing the evolution chain.
///    - forms: Alternate `PokemonForm` entries (sprites/names).
///    - items: Items that this Pokémon can hold.
struct CurrentPokemon {
    var details: PKMPokemon
    var normalAbilities: [PKMAbility]
    var hiddenAbilities: [PKMAbility]
    var species: PKMPokemonSpecies
    var evolution: [EvolutionStage]
    var forms: [PokemonForm]
    var items: [PKMItem]
}
