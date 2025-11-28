//
//  String+FormattedName.swift
//  Pokemon Dex
//
//  Created by David Giron on 27/11/25.
//

import Foundation

extension String {
    func formattedName() -> String {
        var text = self.lowercased()

        text = text
            .replacingOccurrences(of: "-", with: " ")
            .capitalized

        return text
    }
}
