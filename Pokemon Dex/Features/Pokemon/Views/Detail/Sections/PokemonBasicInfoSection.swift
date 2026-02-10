//
//  PokemonBasicInfoSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

/// Top area showing a Pokémon's basic information: index, name, types and short description.
///
/// - Parameters:
///   - order: Pokédex order/index used for display (shown as `#000`).
///   - name: Formatted Pokémon name for the header.
///   - types: Array of display type names used to render `CustomCapsule` badges.
///   - description: Short flavor text or summary for the Pokémon.
struct PokemonBasicInfoSection: View {
    
    // MARK: - Parameters
    let order: Int
    let name: String
    let types: [String]
    let description: String
    
    // MARK: - Body
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
