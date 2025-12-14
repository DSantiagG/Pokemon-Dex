//
//  GenericResourceService.swift
//  Pokemon Dex
//

import Foundation
import PokemonAPI

actor ResourceService<Endpoint: ResourceEndpoints>: Sendable, PagingService, SearchService {
    
    typealias Model = Endpoint.Item

    private var pagedObject: PKMPagedObject<Model>?
    private var resourcesCache: [PKMAPIResource<Model>]?
    private var cache = [String: Model]()

    func fetchInitialPage(limit: Int) async throws -> [Model] {
        let result = try await Endpoint.fetchPage(.initial(pageLimit: limit))
        pagedObject = result
        return try await fetch(from: result.results ?? [])
    }

    func fetchNextPage() async throws -> [Model]? {
        guard let paged = pagedObject, paged.hasNext else { return nil }
        
        let next = try await Endpoint.fetchPage(.continuing(paged, .next))
        pagedObject = next
        let results = try await fetch(from: next.results ?? [])
        return results
    }

    func fetchAllResources() async throws -> [PKMAPIResource<Model>] {
        if let cached = resourcesCache { return cached }
        
        let result = try await Endpoint.fetchPage(.initial(pageLimit: 2000))
        let res = result.results ?? []
        resourcesCache = res
        return res
    }

    func fetch(byName name: String) async throws -> Model {
        try await fetchUsingKey(name) {
            try await Endpoint.fetchByName(name)
        }
    }

    func fetch(byResource resource: PKMAPIResource<Model>) async throws -> Model {
        let key = resource.name ?? resource.url ?? "unknown"
        return try await fetchUsingKey(key) {
            if let success = try? await PokemonAPI().resourceService.fetch(resource) {
                return success
            }
            return try await Endpoint.fetchByName(resource.name ?? "")
        }
    }

    private func fetchUsingKey(_ key: String, _ block: () async throws -> Model) async throws -> Model {
        if let cached = cache[key] { return cached }
        let value = try await block()
        cache[key] = value
        return value
    }

    func fetch(from results: [PKMAPIResource<Model>]) async throws -> [Model] {
        try await withThrowingTaskGroup(of: (Int, Model).self) { group in
            for (index, res) in results.enumerated() {
                group.addTask {
                    let value = try await self.fetch(byResource: res)
                    return (index, value)
                }
            }
            var output: [(Int, Model)] = []
            for try await pair in group {
                output.append(pair)
            }
            return output.sorted { $0.0 < $1.0 }.map { $0.1 }
        }
    }
}
