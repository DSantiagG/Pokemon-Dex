//
//  PKMAbilityFlavorText+EnglishFlavorText.swift
//  Pokemon Dex
//
//  Created by David Giron on 26/11/25.
//

import Foundation

import PokemonAPI

extension [PKMAbilityFlavorText] {
    func englishFlavorText() -> String? {
        let englishEntries = self.filter {
            $0.language?.name == "en"
        }

        if englishEntries.isEmpty {
            return nil
        }

        // 1. Prefer "emerald" if exists
        if let emerald = englishEntries.first(where: { $0.versionGroup?.name == "emerald" }) {
            return emerald.flavorText?.cleanFlavorText()
        }

        // 2. Else use first english available
        return englishEntries.first?.flavorText?.cleanFlavorText()
    }
}
