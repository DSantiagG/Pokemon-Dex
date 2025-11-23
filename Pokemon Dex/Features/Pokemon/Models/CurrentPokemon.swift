//
//  CurrentPokemon.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import PokemonAPI

struct CurrentPokemon {
    var details: PKMPokemon
    var species: PKMPokemonSpecies
    var evolution: [EvolutionStage]
    var types: [PKMType]
}
