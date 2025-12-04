//
//  CurrentPokemon.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import PokemonAPI

struct CurrentPokemon {
    var details: PKMPokemon
    var types: [PKMType]
    var normalAbilities: [PKMAbility]
    var hiddenAbilities: [PKMAbility]
    var species: PKMPokemonSpecies
    var evolution: [EvolutionStage]
    var forms: [PokemonForm]
}
