//
//  DataProvider.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import Foundation
import Combine

/// Centralized container providing shared service instances used across the app.
///
/// `DataProvider` exposes feature services and lightweight storage helpers as
/// a convenient singleton for view models and routers. Keep initialization
/// lightweight; avoid performing heavy work in the initializer.
///
/// Example:
/// ```swift
/// let provider = DataProvider.shared
/// Task { _ = try await provider.pokemonService.fetchInitialPage(limit: 20) }
/// ```
@MainActor
class DataProvider: ObservableObject {

    // MARK: - Shared Instance

    /// The global shared `DataProvider` instance used throughout the app.
    static let shared = DataProvider()

    // MARK: - Services

    /// Service responsible for fetching Pokémon data.
    let pokemonService: PokemonService

    /// Service responsible for fetching ability data.
    let abilityService: AbilityService

    /// Service responsible for fetching item data.
    let itemService: ItemService

    /// Storage abstraction for persisting list layout preferences.
    let listLayoutStorage: ListLayoutStorageProtocol

    // MARK: - Initialization

    /// Creates a new `DataProvider` and constructs the default service
    /// and storage implementations.
    ///
    /// The initializer is private to enforce the singleton pattern; use
    /// `DataProvider.shared` to access the shared instance.
    private init() {
        self.pokemonService = PokemonService()
        self.abilityService = AbilityService()
        self.itemService = ItemService()
        self.listLayoutStorage = ListLayoutStorage()
    }
}
