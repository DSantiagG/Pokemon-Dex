//
//  PKMAbilityFlavorText+EnglishFlavorText.swift
//  Pokemon Dex
//
//  Created by David Giron on 26/11/25.
//

import Foundation

import PokemonAPI

/// Helpers for extracting an English language flavor text from an array of `PKMAbilityFlavorText`.
///
/// This extension provides a small convenience that prefers a version-group-specific
/// English entry (emerald) when available, otherwise returns the first English entry.
/// The returned string is cleaned using `cleanFlavorText()` before being returned.
extension [PKMAbilityFlavorText] {
    /// Return a cleaned English flavor text when available.
    ///
    /// - Returns: A cleaned `String` containing the English flavor text, or `nil` if no English entry exists.
    ///
    /// - Behavior:
    ///   1. Filters entries to those where `language?.name == "en"`.
    ///   2. If an entry for the `emerald` version-group exists it is preferred.
    ///   3. Otherwise the first English entry is returned.
    ///
    /// Example:
    /// ```swift
    /// let flavor = ability.flavorTextEntries?.englishFlavorText()
    /// ```
    func englishFlavorText() -> String? {
        let englishEntries = self.filter {
            $0.language?.name == "en"
        }

        if englishEntries.isEmpty {
            return nil
        }

        // Prefer the 'emerald' version-group when present
        if let emerald = englishEntries.first(where: { $0.versionGroup?.name == "emerald" }) {
            return emerald.flavorText?.cleanFlavorText()
        }

        // Fallback: return the first available English entry
        return englishEntries.first?.flavorText?.cleanFlavorText()
    }
}
