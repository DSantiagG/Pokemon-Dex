//
//  PokemonKind.swift
//  Pokemon Dex
//
//  Created by David Giron on 25/11/25.
//

/// Represents how a Pokémon is presented in the context of an ability.
///
/// This `enum` differentiates between a standard appearance and a hidden
/// appearance (for example, a hidden ability). It conforms to `Hashable` so it
/// can be used in hashed collections (such as sets or dictionary keys).
enum PokemonKind: Hashable {
    /// The Pokémon's standard appearance (visible/normal ability).
    case normal

    /// The Pokémon's hidden appearance (for example, a hidden ability that is
    /// not shown on the standard profile but may exist under certain conditions).
    case hidden
}
