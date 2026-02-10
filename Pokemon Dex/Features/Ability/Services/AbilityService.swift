//
//  AbilityService.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import PokemonAPI

/// Endpoints for fetching ability data from the Pokemon API.
///
/// Conforms to ``ResourceEndpoints`` and provides implementations for
/// listing abilities and fetching a single ability by name.
enum AbilityEndpoints: ResourceEndpoints {
    /// Fetch a paged list of abilities.
    /// - Parameter state: The pagination state to continue from.
    /// - Returns: A `PKMPagedObject<PKMAbility>` containing the page results.
    static func fetchPage(_ state: PaginationState<PKMAbility>) async throws -> PKMPagedObject<PKMAbility> {
        try await PokemonAPI().pokemonService.fetchAbilityList(paginationState: state)
    }

    /// Fetch an ability by its name.
    /// - Parameter name: The ability identifier.
    /// - Returns: A `PKMAbility` model.
    static func fetchByName(_ name: String) async throws -> PKMAbility {
        try await PokemonAPI().pokemonService.fetchAbility(name)
    }
}

/// A ``ResourceService`` specialized for ability endpoints.
typealias AbilityService = ResourceService<AbilityEndpoints>
