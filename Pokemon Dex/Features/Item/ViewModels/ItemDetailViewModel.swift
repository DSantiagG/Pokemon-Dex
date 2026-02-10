//
//  ItemDetailViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import Foundation
import Combine
import SwiftUI

import PokemonAPI

/// View model that loads an item's details and the Pokémon that can hold it.
///
/// Responsible for orchestrating the item fetch and the subsequent retrieval
/// of the Pokémon list that hold the item. Exposes `currentItem` and `state`
/// for the UI to react to loading, success, empty or error states.
class ItemDetailViewModel: ObservableObject, ErrorHandleable{
    
    // MARK: - Published
    /// The currently loaded presentation model combining item details and holding Pokémon.
    @Published var currentItem: CurrentItem?
    /// UI view state used to indicate loading, loaded, notFound or error states.
    @Published var state: ViewState = .idle
    
    // MARK: - Services
    /// Service used to fetch item models (by name or resource).
    private let itemService: ItemService
    /// Service used to fetch Pokémon models referenced by item data.
    private let pokemonService: PokemonService
    
    // MARK: - Init
    init(itemService: ItemService, pokemonService: PokemonService) {
        self.itemService = itemService
        self.pokemonService = pokemonService
    }
    
    // MARK: - Public
    /// Load the item and related data for the provided item name.
    ///
    /// - Parameter name: Optional item slug to load (e.g. "master-ball"). If `nil` or empty
    ///   the view model sets `state = .notFound` and returns immediately.
    func loadItem(name: String?) async {
        
        currentItem = nil
        
        guard let name, !name.isEmpty else {
            state = .notFound
            return
        }
        
        state = .loading
        
        do{
            currentItem = try await fetchAllItemData(name: name)
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading item with name : \(name) failed", userMessage: "Something went wrong while loading this item. Tap retry to check again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadItem(name: name)
                }
            }
            currentItem = nil
        }
    }
    
    // MARK: - Private
    /// Fetch item details and the associated holding Pokémon, returning a `CurrentItem`.
    ///
    /// - Parameter name: Item slug to fetch.
    /// - Returns: A `CurrentItem` containing the decoded `PKMItem` and the list of `PKMPokemon` that hold it, or `nil` when no Pokémon are associated.
    /// - Throws: Propagates errors thrown while fetching the item or Pokémon data.
    private func fetchAllItemData(name: String) async throws -> CurrentItem? {
        
        let item = try await fetchItem(name: name)

        guard let pokemons = try await fetchPokemons(for: item) else { return nil }

        return CurrentItem(
            details: item,
            holdingPokemon: pokemons
        )
    }
    
    /// Fetch a `PKMItem` by name.
    ///
    /// - Parameter name: Item slug.
    /// - Returns: A decoded `PKMItem`.
    /// - Throws: Errors from the `itemService`.
    private func fetchItem(name: String) async throws -> PKMItem {
        try await itemService.fetch(byName: name)
    }
    
    /// Fetch the list of `PKMPokemon` that hold the provided item.
    ///
    /// - Parameter item: The `PKMItem` whose `heldByPokemon` resources will be resolved.
    /// - Returns: An array of `PKMPokemon` or `nil` if the item has no holding Pokémon.
    /// - Throws: Errors from the `pokemonService` when resolving resources.
    private func fetchPokemons(for item: PKMItem) async throws -> [PKMPokemon]? {
        guard let pokemons = item.heldByPokemon else { return nil }
        // Map the heldBy entries to resource descriptors then fetch concrete models
        let pokemonResources = pokemons.compactMap { $0.pokemon }
        return try await pokemonService.fetch(from: pokemonResources)
    }
}

// MARK: - Presentation
extension ItemDetailViewModel {
    
    /// Display-friendly name for the current item.
    ///
    /// - Returns: A formatted name or "Unknown Name" when unavailable.
    var displayName: String {
        currentItem?.details.name?.formattedName() ?? "Unknown Name"
    }
    
    /// Display-friendly category name for the current item.
    ///
    /// - Returns: Formatted category name or "Unknown Category" when unavailable.
    var displayCategory: String {
        currentItem?.details.category?.name?.formattedName() ?? "Unknown Category"
    }
    
    /// User-facing flavor text or description for the item.
    ///
    /// - Returns: Cleaned English flavor text or a default placeholder when missing.
    var displayDescription: String {
        currentItem?.details.flavorTextEntries?.englishFlavorText() ?? "No description available."
    }
    
    /// Accent color derived from the item's category.
    ///
    /// - Returns: A `Color` suitable for UI accents; falls back to `.gray`.
    var displayColor: Color {
        currentItem?.details.category?.name?.categoryColor ?? .gray
    }
    
    /// Numeric cost for the current item.
    ///
    /// - Returns: The item's `cost` or `0` when unknown.
    var displayCost: Int {
        currentItem?.details.cost ?? 0
    }
    
    /// Human-friendly attributes (names) for the item.
    ///
    /// - Returns: An array of attribute display names or an empty array.
    var displayAttributes: [String] {
        currentItem?.details.attributes?.compactMap { $0.name?.formattedName() } ?? []
    }
    
    /// The English effect description for the item.
    ///
    /// - Returns: Cleaned effect text for display or a default placeholder when missing.
    var displayEffect: String {
        currentItem?.details.effectEntries?.first(where: { $0.language?.name == "en" })?.effect?.cleanFlavorText() ?? "No effect available."
    }
}
