//
//  AdaptiveText.swift
//  Pokemon Dex
//
//  Created by David Giron on 27/11/25.
//


import SwiftUI

struct AdaptiveText: View {
    
    let text: String
    var isMultiline: Bool = true
    
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
    
    var adaptiveText: some View {
        Text(text)
            .minimumScaleFactor(0.7)
            .allowsTightening(true)
            .truncationMode(.tail)
    }
    
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
