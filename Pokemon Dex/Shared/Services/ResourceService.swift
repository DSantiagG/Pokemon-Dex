//
//  GenericResourceService.swift
//  Pokemon Dex
//

import Foundation
import PokemonAPI

/// Generic actor responsible for fetching and caching resources for a given `Endpoint`.
///
/// `ResourceService` implements `PagingService` and `SearchService` for the
/// supplied `Endpoint` type. It provides methods to fetch the initial page,
/// paginate, fetch individual resources by name or resource descriptor, and
/// to decode multiple resources in parallel. Results are cached in-memory to
/// reduce duplicate network requests.
///
/// - Note: `Endpoint` must conform to ``ResourceEndpoints`` which defines the
///   concrete API endpoints used by the service.
///
/// Example:
/// ```swift
/// typealias PokemonService = ResourceService<PokemonEndpoint>
/// let service = PokemonService()
/// Task { let first = try await service.fetchInitialPage(limit: 20) }
/// ```
actor ResourceService<Endpoint: ResourceEndpoints>: Sendable, PagingService, SearchService {
    
    typealias Model = Endpoint.Item

    // MARK: - Stored Properties

    /// The current paged object returned by the last paginated fetch (if any).
    ///
    /// Used to drive `fetchNextPage()` and determine whether more pages are available.
    private var pagedObject: PKMPagedObject<Model>?

    /// Cached list of API resources fetched by `fetchAllResources()`.
    ///
    /// Stored to avoid requesting the entire resource index multiple times.
    private var resourcesCache: [PKMAPIResource<Model>]?

    /// In-memory cache keyed by a stable string (name or url) to prevent
    /// repeated fetches of the same `Model` instance.
    private var cache = [String: Model]()

    // MARK: - Paging API

    /// Fetch the initial page of items for the endpoint.
    ///
    /// - Parameter limit: Maximum items to request for the initial page.
    /// - Returns: An array of decoded `Model` objects for the first page.
    /// - Throws: Rethrows any error produced by the underlying endpoint request.
    func fetchInitialPage(limit: Int) async throws -> [Model] {
        let result = try await Endpoint.fetchPage(.initial(pageLimit: limit))
        pagedObject = result
        return try await fetch(from: result.results ?? [])
    }

    /// Fetch the next page of results if available.
    ///
    /// - Returns: An optional array of `Model` objects for the next page, or `nil` if there is no next page.
    /// - Throws: Rethrows errors from the endpoint or item fetch operations.
    func fetchNextPage() async throws -> [Model]? {
        guard let paged = pagedObject, paged.hasNext else { return nil }

        let next = try await Endpoint.fetchPage(.continuing(paged, .next))
        pagedObject = next
        let results = try await fetch(from: next.results ?? [])
        return results
    }

    // MARK: - Resource Index

    /// Fetch all available resource descriptors for the endpoint.
    ///
    /// - Returns: An array of `PKMAPIResource<Model>` representing all resources.
    /// - Throws: Errors from the endpoint fetch.
    func fetchAllResources() async throws -> [PKMAPIResource<Model>] {
        if let cached = resourcesCache { return cached }

        let result = try await Endpoint.fetchPage(.initial(pageLimit: 2000))
        let res = result.results ?? []
        resourcesCache = res
        return res
    }

    // MARK: - Single Resource Fetch

    /// Fetch a resource by its canonical name.
    ///
    /// - Parameter name: The resource name (slug) to fetch.
    /// - Returns: The decoded `Model` for the given name.
    /// - Throws: Errors from the endpoint fetch or underlying decoding.
    func fetch(byName name: String) async throws -> Model {
        try await fetchUsingKey(name) {
            try await Endpoint.fetchByName(name)
        }
    }

    /// Fetch a resource using a `PKMAPIResource` descriptor.
    ///
    /// - Parameter resource: The API resource descriptor (may contain name or url).
    /// - Returns: The decoded `Model` corresponding to the resource.
    /// - Throws: Errors from network requests or decoding.
    func fetch(byResource resource: PKMAPIResource<Model>) async throws -> Model {
        let key = resource.name ?? resource.url ?? "unknown"
        return try await fetchUsingKey(key) {
            if let success = try? await PokemonAPI().resourceService.fetch(resource) {
                return success
            }
            return try await Endpoint.fetchByName(resource.name ?? "")
        }
    }

    // MARK: - Caching Helper

    /// Internal helper that fetches a `Model` using a cache key.
    ///
    /// - Parameters:
    ///   - key: The cache key (usually resource name or url).
    ///   - block: Async closure that performs the network fetch when the key is not cached.
    /// - Returns: The decoded `Model` for the key.
    /// - Throws: Errors thrown by `block`.
    private func fetchUsingKey(_ key: String, _ block: () async throws -> Model) async throws -> Model {
        if let cached = cache[key] { return cached }
        let value = try await block()
        cache[key] = value
        return value
    }

    // MARK: - Bulk Fetch

    /// Fetch and decode a list of `Model` values from an array of resource descriptors.
    ///
    /// - Parameter resources: Array of `PKMAPIResource<Model>` to fetch.
    /// - Returns: An array of decoded `Model` objects in the same order as `resources`.
    /// - Throws: Errors from individual resource fetches.
    func fetch(from resources: [PKMAPIResource<Model>]) async throws -> [Model] {
        try await withThrowingTaskGroup(of: (Int, Model).self) { group in
            for (index, res) in resources.enumerated() {
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
    
    /// Fetch and decode a list of `Model` values from an array of resource names.
    ///
    /// - Parameter names: Array of resource name slugs to fetch.
    /// - Returns: An array of decoded `Model` objects in the same order as `names`.
    /// - Throws: Errors from individual name fetches.
    func fetch(from names: [String]) async throws -> [Model] {
        try await withThrowingTaskGroup(of: (Int, Model).self) { group in
            for (index, name) in names.enumerated() {
                group.addTask {
                    let value = try await self.fetch(byName: name)
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
