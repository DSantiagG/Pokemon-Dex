//
//  PokemonCard.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonCard: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var pokemon: PKMPokemon
    var layout: CardOrientation = .vertical
    
    private var pokemonColor: Color { pokemon.types?.first?.color ?? .gray }

    var body: some View{
        CardContainer(color: pokemonColor, layout: layout) {
            VStack(alignment: .center, spacing: 8) {
                image
                title
                order
                types
            }
        } contentHorizontal: {
            HStack(spacing: 12) {
                image
                VStack(alignment: .leading, spacing: 4) {
                    title
                    types
                }
                Spacer()
                VStack{
                    Spacer()
                    order
                }
            }
        }
    }
    
    private var image: some View {
        URLImage(
            urlString: pokemon.sprites?.other?.officialArtwork?.frontDefault,
            cornerRadius: 5,
            contentMode: .fit
        )
        .shadow(color: pokemonColor, radius: 6)
    }

    private var title: some View {
        AdaptiveText(text: (pokemon.name ?? "Unknown Name").formattedName(), isMultiline: false)
            .bold()
    }
    
    private var order: some View {
        Text(String(format: "#%03d", pokemon.id ?? 0))
            .font(.system(size: layout == .vertical ? 15 : 20, weight: .semibold, design: .rounded))
            .foregroundStyle(pokemonColor)
            .shadow(color: pokemonColor, radius: 4)
    }

    private var types: some View {
        HStack {
            if let types = pokemon.types {
                ForEach(Array(types).enumerated(), id: \.offset) { _, type in 
                    CustomCapsule(text: (type.type?.name ?? "Unknown Type").capitalized, color: type.color)
                }
            }
        }
    }
}

#Preview ("Vertical") {
    PokemonCard(pokemon: PokemonMockFactory.mockBulbasaur(), layout: .vertical)
        .padding()
}

#Preview ("Horizontal") {
    PokemonCard(pokemon: PokemonMockFactory.mockBulbasaur(), layout: .horizontal)
        .frame(height: 90)
        .padding()
}
