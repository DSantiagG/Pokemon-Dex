//
//  SearchService.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//

// MARK: - Search Service Protocol

/// A protocol defining search-related operations used by feature services.
///
/// Conforming types expose two associated types: `Item` is the decoded model
/// used by the UI, and `Resource` represents the lightweight resource
/// descriptors used to drive searches.
protocol SearchService {
    /// The concrete item type returned after resolving resources.
    associatedtype Item

    /// A lightweight resource type used to describe searchable resources.
    associatedtype Resource: IdentifiableResource

    /// Fetch all available resources that can be searched (for example: a list
    /// of resource descriptors or indexes).
    ///
    /// - Returns: An array of `Resource` descriptors.
    func fetchAllResources() async throws -> [Resource]

    /// Resolve a set of `Resource` descriptors into concrete items for display.
    ///
    /// - Parameter resources: The resources selected by the user or discovered
    ///                        during search.
    /// - Returns: An array of resolved `Item` models.
    func fetch(from resources: [Resource]) async throws -> [Item]
}
