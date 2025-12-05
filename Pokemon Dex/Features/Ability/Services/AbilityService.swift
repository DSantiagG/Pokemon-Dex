//
//  AbilityService.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import PokemonAPI

actor AbilityService {
    
    private let api = PokemonAPI()
    private var pagedObject: PKMPagedObject<PKMAbility>?
    
    private var abilityCache = [String: PKMAbility]()
    
    func fetchInitialPage() async throws -> [PKMAbility] {
        let result = try await api.pokemonService.fetchAbilityList(paginationState: .initial(pageLimit: 20))
        pagedObject = result
        return try await fetchAbilities(from: result.results ?? [])
    }
    
    func fetchNextPage() async throws -> [PKMAbility]? {
        guard let paged = pagedObject,
              paged.hasNext else { return nil }
        
        let next = try await api.pokemonService.fetchAbilityList(paginationState: .continuing(paged, .next))
        pagedObject = next
        let abilities = try await fetchAbilities(from: next.results ?? [])
        return abilities
    }
    
    func fetchAllAbilityResources() async throws -> [PKMAPIResource<PKMAbility>] {
        let result = try await api.pokemonService.fetchAbilityList(paginationState: .initial(pageLimit: 2000))
        return result.results ?? []
    }
    
    func fetchAbility(name: String) async throws -> PKMAbility {
        try await fetchAbility(usingKey: name) {
            try await self.api.pokemonService.fetchAbility(name)
        }
    }
    
    func fetchAbility(resource: PKMAPIResource<PKMAbility>) async throws -> PKMAbility {
        let key = resource.name ?? resource.url ?? "unknown"
        return try await fetchAbility(usingKey: key) {
            if let success = try? await self.api.resourceService.fetch(resource) {
                return success
            }
            return try await self.api.pokemonService.fetchAbility(resource.name ?? "")
        }
    }
    
    private func fetchAbility(usingKey key: String, fetcher: () async throws -> PKMAbility) async throws -> PKMAbility {
        if let cached = abilityCache[key] {
            return cached
        }
        let ability = try await fetcher()
        abilityCache[key] = ability
        return ability
    }
    
    func fetchAbilities(from results: [PKMAPIResource<PKMAbility>]) async throws -> [PKMAbility] {
        try await withThrowingTaskGroup(of: (Int, PKMAbility).self) { group in
            for (index, result) in results.enumerated() {
                group.addTask {
                    let ability = try await self.fetchAbility(resource: result)
                    return (index, ability)
                }
            }
            var pairs: [(Int, PKMAbility)] = []
            for try await pair in group {
                pairs.append(pair)
            }
            return pairs.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
}
