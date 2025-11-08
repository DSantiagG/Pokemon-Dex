//
//  PokemonListView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonListView: View {
    @StateObject private var pokemonVM = PokemonViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(pokemonVM.pokemons).enumerated(), id: \.offset) { _, pokemon in
                    PokemonCardView(pokemon: pokemon)
                        .onAppear {
                            Task { await pokemonVM.loadNextPageIfNeeded(currentPokemon: pokemon) }
                        }
                }
            }
            .padding()
            
            if case .loading = pokemonVM.state {
                ProgressView()
                    .padding()
            }
            if case .error(let message, let source) = pokemonVM.state {
                VStack {
                    Text("Error: \(message)")
                    Button("Retry") {
                        Task {
                            switch source {
                            case .initial:
                                await pokemonVM.loadInitialPage()
                            case .pagination:
                                if let last = pokemonVM.pokemons.last {
                                    await pokemonVM.loadNextPageIfNeeded(currentPokemon: last)
                                }
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .task {
            if pokemonVM.pokemons.isEmpty {
                await pokemonVM.loadInitialPage()
            }
        }
    }
}

#Preview {
    ScrollView{
        PokemonListView()
    }
}
