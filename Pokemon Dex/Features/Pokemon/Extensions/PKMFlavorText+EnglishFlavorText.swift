//
//  PKMFlavorText+EnglishFlavorText.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/11/25.
//
import PokemonAPI

extension [PKMFlavorText] {
    /// Return a cleaned English flavor text when available from an array of `PKMFlavorText`.
    ///
    /// - Returns: A cleaned `String` containing the English flavor text, or `nil` if no English entry exists.
    ///
    /// Behavior:
    /// 1. Filters entries to those where `language?.name == "en"`.
    /// 2. Prefers the `"emerald"` version entry when present.
    /// 3. Otherwise returns the first English entry found.
    func englishFlavorText() -> String? {
        let englishEntries = self.filter {
            $0.language?.name == "en"
        }

        if englishEntries.isEmpty {
            return nil
        }

        // 1. Prefer "emerald" if exists
        if let emerald = englishEntries.first(where: { $0.version?.name == "emerald" }) {
            return emerald.flavorText?.cleanFlavorText()
        }

        // 2. Else use first english available
        return englishEntries.first?.flavorText?.cleanFlavorText()
    }
}
