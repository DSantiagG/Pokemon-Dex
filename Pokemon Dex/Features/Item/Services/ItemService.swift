//
//  ItemService.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import Foundation
import PokemonAPI

/// Endpoints for fetching item resources from the Pokemon API.
///
/// Conforms to ``ResourceEndpoints`` and provides implementations for
/// listing items and fetching a single item by name.
enum ItemEndpoints: ResourceEndpoints {
    /// Fetch a paged list of items.
    ///
    /// - Parameter state: Pagination state used to request a specific page.
    /// - Returns: A `PKMPagedObject<PKMItem>` containing the page results.
    /// - Throws: Rethrows errors from the underlying `PokemonAPI` call.
    static func fetchPage(_ state: PaginationState<PKMItem>) async throws -> PKMPagedObject<PKMItem> {
        try await PokemonAPI().itemService.fetchItemList(paginationState: state)
    }

    /// Fetch an item by its name.
    ///
    /// - Parameter name: The item identifier (name).
    /// - Returns: A `PKMItem` model.
    /// - Throws: Rethrows errors from the underlying `PokemonAPI` call when the item cannot be fetched.
    static func fetchByName(_ name: String) async throws -> PKMItem {
        try await PokemonAPI().itemService.fetchItem(name)
    }
}

/// A `ResourceService` specialized for item endpoints.
typealias ItemService = ResourceService<ItemEndpoints>
