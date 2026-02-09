//
//  PKMVersionGroupFlavorText+EnglishFlavorText.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import PokemonAPI

extension [PKMVersionGroupFlavorText] {
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
