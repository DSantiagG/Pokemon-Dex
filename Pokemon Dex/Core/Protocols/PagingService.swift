//
//  PagedResourceService.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//


import Foundation

// MARK: - Paging Service Protocol

/// A protocol describing a paginated data source used by view models.
///
/// Conforming types supply an `associatedtype Item` and implement methods to
/// fetch the first page and subsequent pages.
protocol PagingService<Item> {
    /// The type of element returned by the paging service.
    associatedtype Item

    /// Fetch the initial page of items.
    ///
    /// - Parameter limit: Optional page size hint. Implementations may ignore it.
    /// - Returns: An array containing the first page of items.
    func fetchInitialPage(limit: Int) async throws -> [Item]

    /// Fetch the next page of items.
    ///
    /// - Returns: An array with the next page of items, or `nil` when there are
    ///            no more pages to load.
    func fetchNextPage() async throws -> [Item]?
}
