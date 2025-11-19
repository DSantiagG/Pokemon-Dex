//
//  PokemonCardView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonCardView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var pokemon: PKMPokemon
    
    private var pokemonColor: Color {
        (pokemon.types?.first?.type?.name ?? "unknown").pokemonTypeColor
    }

    var body: some View{
        VStack {
            URLImage(
                urlString: pokemon.sprites?.other?.officialArtwork?.frontDefault,
                cornerRadius: 5,
                contentMode: .fit
            )
            .shadow(color: pokemonColor, radius: 6)
            
            Text((pokemon.name ?? "Unknown Name").capitalized)
                .bold()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            HStack {
                if let types = pokemon.types {
                    ForEach(Array(types).enumerated(), id: \.offset) { _, type in
                        Text((type.type?.name ?? "Unknown Type").capitalized)
                            .foregroundStyle(Color.white)
                            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                            .background(RoundedRectangle(cornerRadius: 13)
                                .fill((type.type?.name ?? "unknown").pokemonTypeColor))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(pokemonColor.opacity(0.1))
                .if(colorScheme == .light) { view in
                    view.shadow(color: pokemonColor, radius: 8)
                }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(pokemonColor, lineWidth: 1)
        )
    }
}

struct PokemonCardPreviewLoader: View {
    @StateObject private var pokemonVM = PokemonViewModel(pokemonService: PokemonService())
    
    var body: some View {
        VStack {
            if let pokemon = pokemonVM.currentPokemon {
                PokemonCardView(pokemon: pokemon.details)
            }
        }
        .task {
            await pokemonVM.loadPokemon(name: "umbreon")
        }
    }
}

#Preview {
    PokemonCardPreviewLoader()
        .padding()
        .preferredColorScheme(.light)
}
