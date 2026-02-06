//
//  ResourceEndpoints.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//
import PokemonAPI

// MARK: - Resource Endpoints Protocol

/// Defines the static endpoint methods used to fetch paginated resources and
/// to resolve a single resource by name.
///
/// Conforming types typically map to a specific API resource (for example
/// `Pokemon`, `Ability`, or `Item`) and provide the implementation details for
/// network requests used by higher-level services.
protocol ResourceEndpoints {
    /// The concrete decoded type for this resource endpoint.
    associatedtype Item: Decodable

    /// Fetch a page for the provided pagination state.
    ///
    /// - Parameter state: The current `PaginationState` describing the page to fetch.
    /// - Returns: A `PKMPagedObject` containing the decoded page of `Item`.
    static func fetchPage(_ state: PaginationState<Item>) async throws -> PKMPagedObject<Item>

    /// Fetch a single resource by its name identifier.
    ///
    /// - Parameter name: The resource name to resolve.
    /// - Returns: The decoded resource instance of type `Item`.
    static func fetchByName(_ name: String) async throws -> Item
}
