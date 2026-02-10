//
//  AdaptiveText.swift
//  Pokemon Dex
//
//  Created by David Giron on 27/11/25.
//


import SwiftUI

/// A text view that adapts line limits based on content shape.
///
/// - Parameters:
///   - text: The text content to display.
///   - isMultiline: Whether multi-line rendering is allowed. When `false` the text is forced to a single line.
struct AdaptiveText: View {
    
    // MARK: - Properties
    let text: String
    var isMultiline: Bool = true
    
    // MARK: - View
    var body: some View {
        if isSingleWord(text) || !isMultiline {
            adaptiveText
                .lineLimit(1)
        } else {
            adaptiveText
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Computed Views
    
    /// The base text view with adaptive scaling and truncation.
    var adaptiveText: some View {
        Text(text)
            .minimumScaleFactor(0.7)
            .allowsTightening(true)
            .truncationMode(.tail)
    }
    
    //MARK: - Helpers
    
    /// Checks if the provided string is a single word (no spaces) after trimming whitespace.
    private func isSingleWord(_ value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
             .split(separator: " ").count == 1
    }
}

#Preview ("Single Word"){
    AdaptiveText(text: "Charizard")
        .frame(width: 60)
}

#Preview ("Two Words"){
    AdaptiveText(text: "Charizard Mega X")
        .frame(width: 60)
}
