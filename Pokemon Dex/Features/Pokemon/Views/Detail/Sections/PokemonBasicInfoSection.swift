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
    let flavorText: String
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(String(format: "#%03d", order))
                .foregroundStyle(.secondary)
                .padding(.bottom, -16)
            
            Text(name.capitalized)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            HStack {
                if let types {
                    ForEach(Array(types).enumerated(), id: \.offset) { _, type in
                        Text((type.type?.name ?? "Unknown Type").capitalized)
                            .font(.system(size: 19, weight: .semibold, design: .default))
                            .foregroundStyle(Color.white)
                            .padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
                            .background(type.color)
                            .clipShape(Capsule())
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
            }
            
            Text(flavorText)
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
        flavorText: "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun's rays, the seed grows progressively larger."
    )
    .padding(.horizontal)
}
