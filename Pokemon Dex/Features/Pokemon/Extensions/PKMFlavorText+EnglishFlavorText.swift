//
//  PKMFlavorText+EnglishFlavorText.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/11/25.
//
import PokemonAPI

extension [PKMFlavorText] {
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


