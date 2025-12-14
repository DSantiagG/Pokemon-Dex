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
    let types: [String]
    let description: String
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(String(format: "#%03d", order))
                .foregroundStyle(.secondary)
                .padding(.bottom, -10)
            
            AdaptiveText(text: name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            HStack {
                ForEach(types, id: \.self) { type in
                    CustomCapsule(text: type, fontSize: 19, fontWeight: .semibold, color: type.pokemonTypeColor, horizontalPadding: 15)
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
        types: [ "Grass", "Poison" ],
        description: "Bulbasaur can be seen napping in bright sunlight. There is a seed on its back. By soaking up the sun's rays, the seed grows progressively larger."
    )
    .padding(.horizontal)
}
