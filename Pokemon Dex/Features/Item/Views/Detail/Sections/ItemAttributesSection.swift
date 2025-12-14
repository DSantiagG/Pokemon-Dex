//
//  ItemAttributesSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import SwiftUI
import PokemonAPI

struct ItemAttributesSection: View {
    
    let attributes: [String]
    let color: Color
    
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 8)]
    
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
