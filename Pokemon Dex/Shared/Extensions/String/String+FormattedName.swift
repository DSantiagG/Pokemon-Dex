//
//  String+FormattedName.swift
//  Pokemon Dex
//
//  Created by David Giron on 27/11/25.
//

import Foundation

extension String {
    /// Convert a hyphenated raw name into a human-friendly capitalized string.
    ///
    /// Examples:
    /// - "master-ball" -> "Master Ball"
    /// - "charizard" -> "Charizard"
    ///
    /// - Returns: A capitalized, human-friendly string where hyphens are replaced by spaces.
    func formattedName() -> String {
        var text = self.lowercased()

        text = text
            .replacingOccurrences(of: "-", with: " ")
            .capitalized

        return text
    }
}
