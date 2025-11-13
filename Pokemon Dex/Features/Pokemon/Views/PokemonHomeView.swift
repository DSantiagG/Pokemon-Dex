//
//  PokemonHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

struct PokemonHomeView: View {
    
    @EnvironmentObject private var pokemonVM: PokemonViewModel
    
    var body: some View {
        Group{
            if case .loaded = pokemonVM.state, pokemonVM.pokemons.isEmpty {
                InfoStateView(message: "No Pokémon found.\nTry catching some first!")
            }else{
                NavigationContainerView{
                    ViewStateView(viewModel: pokemonVM) {
                        PokemonListView()
                    }
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
    PokemonHomeView()
        .environmentObject(PokemonViewModel())
        .environmentObject(NavigationRouter())
}
