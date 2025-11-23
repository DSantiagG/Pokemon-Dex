//
//  PokemonCardView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

enum CardOrientation {
    case vertical
    case horizontal
}

struct PokemonCardView: View {
    
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
        Text((pokemon.name ?? "Unknown Name").capitalized)
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.7)
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
                    Text((type.type?.name ?? "Unknown Type").capitalized)
                        .foregroundStyle(Color.white)
                        .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                        .background(RoundedRectangle(cornerRadius: 13)
                            .fill(type.color))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
        }
    }
}

struct PokemonCardPreviewLoader: View {
    @StateObject private var pokemonVM = PokemonDetailViewModel(pokemonService: PokemonService())
    
    var layout: CardOrientation
    
    var body: some View {
        VStack {
            if let pokemon = pokemonVM.currentPokemon {
                PokemonCardView(pokemon: pokemon.details, layout: layout)
            }
        }
        .task {
            await pokemonVM.loadPokemon(name: "bulbasaur")
        }
    }
}

#Preview ("Vertical") {
    PokemonCardPreviewLoader(layout: .vertical)
        .padding()
}

#Preview ("Horizontal") {
    PokemonCardPreviewLoader(layout: .horizontal)
        .frame(height: 170)
        .padding()
}
