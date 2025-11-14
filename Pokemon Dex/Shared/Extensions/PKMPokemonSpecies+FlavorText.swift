//
//  PKMPokemonSpecies+FlavorText.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/11/25.
//
import PokemonAPI

extension PKMPokemonSpecies {
    func englishFlavorText() -> String? {
        let englishEntries = flavorTextEntries?.filter {
            $0.language?.name == "en"
        } ?? []

        if englishEntries.isEmpty {
            return nil
        }

        // 1. prefer "firered" if exists
        if let emerald = englishEntries.first(where: { $0.version?.name == "emerald" }) {
            return emerald.flavorText?.cleanFlavorText(pokemonName: name)
        }

        // 2. else use first english available
        return englishEntries.first?.flavorText?.cleanFlavorText(pokemonName: name)
    }
}
