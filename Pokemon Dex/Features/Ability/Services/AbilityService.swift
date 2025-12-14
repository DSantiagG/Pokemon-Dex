//
//  AbilityService.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import PokemonAPI

enum AbilityEndpoints: ResourceEndpoints {
    static func fetchPage(_ state: PaginationState<PKMAbility>) async throws -> PKMPagedObject<PKMAbility> {
        try await PokemonAPI().pokemonService.fetchAbilityList(paginationState: state)
    }

    static func fetchByName(_ name: String) async throws -> PKMAbility {
        try await PokemonAPI().pokemonService.fetchAbility(name)
    }
}

typealias AbilityService = ResourceService<AbilityEndpoints>
