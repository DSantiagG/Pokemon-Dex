//
//  PokemonBasicInfoSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

struct PokemonBasicInfoSection: View {
    let order: Int
    let name: String
    let types: [PKMPokemonType]?
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(String(format: "#%03d", order))
                .foregroundStyle(.secondary)
                .padding(.bottom, -10)
            
            Text(name.capitalized)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            HStack {
                if let types {
                    ForEach(Array(types).enumerated(), id: \.offset) { _, type in
                        CustomCapsule(text: (type.type?.name ?? "Unknown Type").capitalized, fontSize: 19, fontWeight: .semibold, color: type.color, horizontalPadding: 15)
                    }
                }
            }
            Text(description)
        }
    }
}

#Preview {
    PokemonBasicInfoSection(
        order: 1,
        name: "Bulbasaur",
        types: [
            PokemonMockFactory.mockType(name: "grass"),
            PokemonMockFactory.mockType(name: "poison")
        ],
        description: "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun's rays, the seed grows progressively larger."
    )
    .padding(.horizontal)
}
