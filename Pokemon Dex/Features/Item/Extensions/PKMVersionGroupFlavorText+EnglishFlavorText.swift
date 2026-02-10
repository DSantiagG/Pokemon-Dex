//
//  PKMVersionGroupFlavorText+EnglishFlavorText.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import PokemonAPI

/// Helpers for extracting English flavor text from version group entries.
extension [PKMVersionGroupFlavorText] {
    /// Returns the preferred English flavor text from the entries.
    ///
    /// - Returns: The cleaned English flavor text if found, otherwise `nil`.
    /// - Note: Prefers the entry whose `versionGroup.name == "emerald"` when available.
    func englishFlavorText() -> String? {
        let englishEntries = self.filter {
            $0.language?.name == "en"
        }

        if englishEntries.isEmpty {
            return nil
        }

        // 1. Prefer "emerald" if exists
        if let emerald = englishEntries.first(where: { $0.versionGroup?.name == "emerald" }) {
            return emerald.text?.cleanFlavorText()
        }

        // 2. Else use first english available
        return englishEntries.first?.text?.cleanFlavorText()
    }
}
