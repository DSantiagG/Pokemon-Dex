//
//  EvolutionStage.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//


/// Represents a single stage in a Pokémon's evolution chain.
///
/// - Parameters:
///   - `name`: Optional Pokémon name at this stage.
///   - `sprite`: Optional URL string for the stage's sprite artwork.
struct EvolutionStage {
    let name: String?
    let sprite: String?
}
