//
//  PokemonDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonDetailView: View {
    @EnvironmentObject private var pokemonVM: PokemonViewModel
    let pokemonName: String
    
    var body: some View {
        Group {
            if let pokemon = pokemonVM.currentPokemon, (pokemon.name ?? "") == pokemonName {
                VStack(spacing: 8) {
                    URLImage(
                        urlString: pokemon.sprites?.other?.officialArtwork?.frontDefault,
                        cornerRadius: 5,
                        contentMode: .fit
                    )
                    
                    Text((pokemon.name ?? "Unknown Name").capitalized)
                        .font(.largeTitle.bold())
                    if let height = pokemon.height {
                        Text("Height: \(String(describing: height))")
                    }
                    
                }
            } else {
                ProgressView()
            }
        }
        .task {
            await pokemonVM.loadPokemonIfNeeded(name: pokemonName)
        }
    }
}

#Preview {
    PokemonDetailView(pokemonName: "pikachu")
        .padding()
        .environmentObject(PokemonViewModel())
}
