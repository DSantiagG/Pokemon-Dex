//
//  PokemonListView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonListView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    @EnvironmentObject private var pokemonVM: PokemonViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns) {
                ForEach(Array(pokemonVM.pokemons).enumerated(), id: \.offset) { _, pokemon in
                    PokemonCardView(pokemon: pokemon)
                        .padding(2)
                        .onAppear {
                            Task { await pokemonVM.loadNextPageIfNeeded(pokemon: pokemon)
                            }
                        }
                        .onTapGesture {
                            router.push(.pokemonDetail(name: pokemon.name ?? "Unknown Name"))
                        }
                }
            }
        }
    }
}

struct PokemonListPreviewLoader: View {
    @StateObject private var pokemonVM = PokemonViewModel(pokemonService: PokemonService())
    
    var body: some View {
        
        ScrollView{
            PokemonListView()
                .padding(.horizontal)
        }
        .environmentObject(pokemonVM)
        .environmentObject(NavigationRouter())
        .task {
            if pokemonVM.pokemons.isEmpty {
                await pokemonVM.loadInitialPage()
            }
        }
    }
}

#Preview {
    PokemonListPreviewLoader()
}
