//
//  PokemonCardView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonCardView: View {
    var pokemon: PKMPokemon
    var body: some View{
        VStack {
            URLImage(
                urlString: pokemon.sprites?.other?.officialArtwork?.frontDefault,
                contentMode: .fit
            )
            .aspectRatio(1, contentMode: .fit)
            
            Text(pokemon.name ?? "Unknown Name")
                .bold()
            
            HStack {
                if let types = pokemon.types {
                    ForEach(Array(types).enumerated(), id: \.offset) { _, type in
                        Text(type.type?.name ?? "Unknown Name")
                            .foregroundStyle(Color.white)
                            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                            .background(RoundedRectangle(cornerRadius: 13)
                                .fill(.green.opacity(0.9)))
                    }
                }
            }
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .border(.black, width: 1)
    }
}

struct PokemonCardPreviewLoader: View {
    @StateObject private var viewModel = PokemonViewModel()
    @State private var pokemon: PKMPokemon?

    var body: some View {
        Group {
            if let pokemon = pokemon {
                PokemonCardView(pokemon: pokemon)
            } else {
                ProgressView("Loading Pokémon...")
                    .task {
                        pokemon = await viewModel.fetchPokemonByName(name: "pikachu")
                    }
            }
        }
        .padding()
    }
}

#Preview {
    PokemonCardPreviewLoader()
}
