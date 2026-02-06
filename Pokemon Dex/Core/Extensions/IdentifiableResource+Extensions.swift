//
//  IdentifiableResource+Extensions.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//

import Foundation
import PokemonAPI

// MARK: - PKMAPIResource: IdentifiableResource

/// Make `PKMAPIResource` conform to `IdentifiableResource` by exposing
/// a stable `resourceName` that prefers `name`, then `url`, then a fallback.
extension PKMAPIResource: IdentifiableResource {
    var resourceName: String { name ?? url ?? "unknown" }
}

// MARK: - PKMPokemon: IdentifiableResource

/// Provide a readable `resourceName` for `PKMPokemon`.
/// Uses the pokemon's `name` when available, otherwise returns `"unknown"`.
extension PKMPokemon: IdentifiableResource {
    var resourceName: String { name ?? "unknown" }
}

// MARK: - PKMItem: IdentifiableResource

/// Provide a readable `resourceName` for `PKMItem`.
/// Uses the item's `name` when available, otherwise returns `"unknown"`.
extension PKMItem: IdentifiableResource {
    var resourceName: String { name ?? "unknown" }
}

// MARK: - PKMAbility: IdentifiableResource

/// Provide a readable `resourceName` for `PKMAbility`.
/// Uses the ability's `name` when available, otherwise returns `"unknown"`.
extension PKMAbility: IdentifiableResource {
    var resourceName: String { name ?? "unknown" }
}
