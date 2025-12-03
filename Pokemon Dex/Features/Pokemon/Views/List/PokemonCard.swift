//
//  PokemonCard.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonCard: View {
    
    enum CardOrientation {
        case vertical
        case horizontal
    }
    
    @Environment(\.colorScheme) private var colorScheme
    
    var pokemon: PKMPokemon
    var layout: CardOrientation = .vertical
    
    private var pokemonColor: Color { pokemon.types?.first?.color ?? .gray }

    var body: some View{
        VStack {
            switch layout {
            case .vertical:
                VStack(alignment: .center, spacing: 8) {
                    imageView
                    titleView
                    orderView
                    typesView
                }
            case .horizontal:
                HStack(spacing: 12) {
                    imageView
                    VStack(alignment: .leading, spacing: 4) {
                        titleView
                        typesView
                    }
                    Spacer()
                    VStack{
                        Spacer()
                        orderView
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(pokemonColor.opacity(0.1))
                .if(colorScheme == .light) { view in
                    view.shadow(color: pokemonColor.opacity(0.5), radius: 6)
                }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(pokemonColor, lineWidth: 1)
        )
    }
    
    private var imageView: some View {
        URLImage(
            urlString: pokemon.sprites?.other?.officialArtwork?.frontDefault,
            cornerRadius: 5,
            contentMode: .fit
        )
        .shadow(color: pokemonColor, radius: 6)
    }

    private var titleView: some View {
        AdaptiveText(text: (pokemon.name ?? "Unknown Name").formattedName(), isMultiline: false)
            .bold()
    }
    
    private var orderView: some View {
        Text(String(format: "#%03d", pokemon.id ?? 0))
            .font(.system(size: layout == .vertical ? 15 : 20, weight: .semibold, design: .rounded))
            .foregroundStyle(pokemonColor)
            .shadow(color: pokemonColor, radius: 4)
    }

    private var typesView: some View {
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
    let pokemon = PokemonMockFactory.mockBulbasaur()
    PokemonCard(pokemon: pokemon, layout: .vertical)
        .padding()
}

#Preview ("Horizontal") {
    let pokemon = PokemonMockFactory.mockBulbasaur()
    PokemonCard(pokemon: pokemon, layout: .horizontal)
        .frame(height: 100)
        .padding()
}
