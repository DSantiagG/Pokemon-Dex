//
//  PokemonFavoritesService.swift
//  Pokemon Dex
//
//  Created by David Giron on 30/12/25.
//
import Foundation

/// Actor responsible for storing and managing the user's favorite Pokémon list.
///
/// `PokemonFavoritesService` provides a lightweight, ordered favorites collection
/// persisted to `UserDefaults`. The actor ensures thread-safe access to the in-memory
/// set and ordering array.
///
/// Example:
/// ```swift
/// await favoritesService.toggle(name: "pikachu")
/// let favorites = await favoritesService.getAll()
/// ```
actor PokemonFavoritesService {
    
    // MARK: - Persistence
    
    private let key = "favorite.pokemons"
    private let storage = UserDefaults.standard
    
    // MARK: - In-memory state
    
    /// Set for fast membership tests.
    private var favoritesSet: Set<String> = []
    /// Ordered list preserving the user's favorite insertion order.
    private var favoritesOrder: [String] = []
    
    // MARK: - Init
    
    init() {
        let saved = storage.stringArray(forKey: key) ?? []
        self.favoritesOrder = saved
        self.favoritesSet = Set(saved)
    }
    
    // MARK: - API
    /// Toggle the favorite state for the provided Pokémon name.
    ///
    /// - Parameter name: Canonical Pokémon name (slug) used as the identifier.
    /// - Behavior: If `name` is already a favorite it is removed; otherwise it is appended to the end of the favorites order.
    /// - Note: The operation persists the updated order to `UserDefaults`.
    func toggle(name: String) {
        if favoritesSet.contains(name) {
            favoritesSet.remove(name)
            favoritesOrder.removeAll { $0 == name }
        } else {
            favoritesSet.insert(name)
            favoritesOrder.append(name)
        }
        persist()
    }
    
    /// Return all favorite Pokémon names in the saved order.
    ///
    /// - Returns: An array of Pokémon name slugs in insertion order (oldest first).
    func getAll() -> [String] {
        favoritesOrder
    }
    
    /// Check whether a Pokémon is currently marked as favorite.
    ///
    /// - Parameter name: Pokémon name slug to check.
    /// - Returns: `true` when the name is in the favorites set.
    func isFavorite(name: String) -> Bool {
        favoritesSet.contains(name)
    }
    
    // MARK: - Persistence helper
    
    /// Persist the ordered favorites array to `UserDefaults`.
    private func persist() {
        storage.set(favoritesOrder, forKey: key)
    }
}
