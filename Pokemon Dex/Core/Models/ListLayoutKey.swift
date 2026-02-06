//
//  ListLayoutKey.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//


import Foundation

/// A key representing the persisted list layout preference for a specific feature.
///
/// Each case maps to a `UserDefaults`-friendly raw string used to store the
/// user's preferred layout for that feature.
enum ListLayoutKey: String {
    /// Pokémon list layout preference key.
    case pokemon = "layout.pokemon"

    /// Ability list layout preference key.
    case ability = "layout.ability"

    /// Item list layout preference key.
    case item = "layout.item"

    // MARK: - Defaults

    /// The default ``ListLayout`` used for this feature when no preference is stored.
    ///
    /// - `.pokemon`, `.item` -> ``ListLayout/twoColumns``
    /// - `.ability` -> ``ListLayout/singleColumn``
    var defaultLayout: ListLayout {
        switch self {
        case .pokemon, .item:
            return .twoColumns
        case .ability:
            return .singleColumn
        }
    }
}
