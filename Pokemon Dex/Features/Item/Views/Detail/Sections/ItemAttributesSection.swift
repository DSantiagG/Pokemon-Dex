//
//  ItemAttributesSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import SwiftUI
import PokemonAPI

/// Displays a card of item attributes as a responsive grid of capsules.
///
/// - Parameters:
///   - attributes: Array of attribute display strings (pre-formatted).
///   - color: Accent color used for capsules and section styling.
///
/// - Note: Renders nothing when `attributes` is empty.
struct ItemAttributesSection: View {
    
    // MARK: - Parameters
    
    let attributes: [String]
    let color: Color
    
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 8)]
    
    // MARK: - Body
    
    var body: some View {
       if !attributes.isEmpty {
            SectionCard(text: "Attributes", color: color) {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                    ForEach(attributes, id: \.self) { attribute in
                        CustomCapsule(text: attribute, fontSize: 18, fontWeight: .semibold, color: color, horizontalPadding: 15, isMultiline: false)
                    }
                }
            }
        }
    }
}

#Preview {
    let attributes = ItemMockFactory.mockMasterBall().attributes?.compactMap { $0.name?.formattedName() } ?? []
    ItemAttributesSection(attributes: attributes, color: .red)
        .padding()
}
