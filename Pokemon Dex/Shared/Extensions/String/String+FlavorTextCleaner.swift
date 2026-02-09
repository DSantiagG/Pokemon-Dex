//
//  String+FlavorTextCleaner.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/11/25.
//

import Foundation

extension String {
    /// Clean and normalize Pokédex flavor text for display.
    ///
    /// This method removes control characters (page breaks, soft hyphens),
    /// fixes hyphenation/newline artifacts, normalizes spacing, and converts
    /// fully-uppercase words into capitalized form (only the first letter uppercase).
    ///
    /// - Returns: A cleaned, trimmed string suitable for in-app presentation.
    func cleanFlavorText() -> String {
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
            .replacingOccurrences(of: "  ", with: " ")         // double space

        // Converts fully UPPERCASE words (with more than 1 letter) into capitalized format
        // (only first letter uppercase). This improves readability for flavor text.
        let words = text.split(separator: " ")

        let fixedWords = words.map { word -> String in
            let w = String(word)

            if w == w.uppercased(), w.count > 1 {
                return w.capitalized
            }
            return w
        }

        text = fixedWords.joined(separator: " ")

        // Remove leading and trailing spaces/newlines
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)

        return text
    }
}
