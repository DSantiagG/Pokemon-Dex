//
//  String+FormattedGeneration.swift
//  Pokemon Dex
//
//  Created by David Giron on 26/11/25.
//

import Foundation

extension String {
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
