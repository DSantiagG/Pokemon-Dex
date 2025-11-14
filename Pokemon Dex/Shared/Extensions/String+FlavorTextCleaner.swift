//
//  String+FlavorTextCleaner.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/11/25.
//

import Foundation

extension String {
    func cleanFlavorText(pokemonName: String? = nil) -> String {
        var text = self
        
        text = text
            .replacingOccurrences(of: "\u{000C}", with: " ") // page break -> space
            .replacingOccurrences(of: "\u{00ad}\n", with: "") // soft hyphen + newline
            .replacingOccurrences(of: "\u{00ad}", with: "")   // soft hyphen
            .replacingOccurrences(of: " -\n", with: " - ")     // hyphen spacing
            .replacingOccurrences(of: "-\n", with: "-")        // hyphen before newline
            .replacingOccurrences(of: "\n", with: " ")         // normal newline -> space
            .replacingOccurrences(of: "POKéMON", with: "Pokémon")
            .replacingOccurrences(of: "POKEMON", with: "Pokémon")
            .replacingOccurrences(of: "\u{00A0}", with: " ")   // non-breaking space -> space
            .replacingOccurrences(of: " ", with: " ")         // double space
        
        if let name = pokemonName {
            let upper = name.uppercased()
            let capitalized = name.capitalized
            // reemplazar solo si aparece en mayúsculas
            text = text.replacingOccurrences(of: upper, with: capitalized)
        }
        
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
