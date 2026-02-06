//
//  ListLayoutStorage.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//


import Foundation

/// Storage protocol for persisting and retrieving list layout preferences.
///
/// Implementations provide a small API used by view models to store the user's
/// preferred `ListLayout` for a given `ListLayoutKey`.
protocol ListLayoutStorageProtocol {
    /// Return the stored layout for the provided key or the key's default.
    func getLayout(for key: ListLayoutKey) -> ListLayout

    /// Persist the layout for the provided key.
    func setLayout(_ layout: ListLayout, for key: ListLayoutKey)
}

// MARK: - Default UserDefaults-based Implementation

/// Default `ListLayoutStorage` implementation that persists preferences in
/// `UserDefaults` using the key's raw value.
///
/// Example:
/// ```swift
/// let storage = ListLayoutStorage()
/// storage.setLayout(.singleColumn, for: .ability)
/// let layout = storage.getLayout(for: .ability)
/// ```
final class ListLayoutStorage: ListLayoutStorageProtocol {
    
    private let defaults = UserDefaults.standard
    
    func getLayout(for key: ListLayoutKey) -> ListLayout {
        guard
            let rawValue = defaults.string(forKey: key.rawValue),
            let layout = ListLayout(rawValue: rawValue)
        else {
            return key.defaultLayout
        }
        return layout
    }
    
    func setLayout(_ layout: ListLayout, for key: ListLayoutKey) {
        defaults.set(layout.rawValue, forKey: key.rawValue)
    }
}
