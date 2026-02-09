//
//  String+FormattedGeneration.swift
//  Pokemon Dex
//
//  Created by David Giron on 26/11/25.
//

import Foundation

extension String {
    /// Format a generation raw identifier (e.g. "generation-iii") into a user-friendly string.
    ///
    /// - Returns: A user-facing string for the generation (e.g. "Generation III") or a capitalized fallback.
    func formattedGeneration() -> String {
        let raw = self.lowercased()

        guard raw.hasPrefix("generation-") else {
            guard let first = raw.first else { return self }
            return first.uppercased() + raw.dropFirst()
        }

        let suffix = raw.replacingOccurrences(of: "generation-", with: "")

        let roman = suffix.uppercased()

        return "Generation \(roman)"
    }
}
