//
//  AbilityService.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import PokemonAPI

private enum AbilityEndpoints: ResourceEndpoints {
    static func fetchPage(_ state: PaginationState<PKMAbility>) async throws -> PKMPagedObject<PKMAbility> {
        try await PokemonAPI().pokemonService.fetchAbilityList(paginationState: state)
    }

    static func fetchByName(_ name: String) async throws -> PKMAbility {
        try await PokemonAPI().pokemonService.fetchAbility(name)
    }
}

actor AbilityService: PagingService, SearchService {
    
    private let core = ResourceService<AbilityEndpoints>()
    
    // MARK: - Pagination
    func fetchInitialPage() async throws -> [PKMAbility] {
        try await core.fetchInitialPage()
    }
    
    func fetchNextPage() async throws -> [PKMAbility]? {
        try await core.fetchNextPage()
    }
    
    func fetchAllResources() async throws -> [PKMAPIResource<PKMAbility>] {
        try await core.fetchAllResources()
    }
    
    // MARK: - Fetch by name / resource
    func fetch(name: String) async throws -> PKMAbility {
        try await core.fetch(byName: name)
    }
    
    func fetch(resource: PKMAPIResource<PKMAbility>) async throws -> PKMAbility {
        try await core.fetch(byResource: resource)
    }
    
    // MARK: - Fetch List
    func fetch(from resources: [PKMAPIResource<PKMAbility>]) async throws -> [PKMAbility] {
        try await core.fetch(from: resources)
    }
}
