//
//  PokemonHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

struct PokemonHomeView: View {
    
    @StateObject private var pokemonVM = PokemonHomeViewModel(pokemonService: DataProvider.shared.pokemonService)
    
    var body: some View {
        Group{
            if case .notFound = pokemonVM.state {
                InfoStateView(primaryText: "No Pokémon found.", secondaryText: "Try catching some first!")
            }else{
                NavigationContainer {
                    ScrollView {
                        ViewStateHandler(viewModel: pokemonVM) {
                            PokemonListView(pokemons: pokemonVM.pokemons, onItemAppear: { pokemon in
                                Task { await pokemonVM.loadNextPageIfNeeded(pokemon: pokemon) }
                            })
                        }
                        .padding(.horizontal)
                    }
                    .toolbarRole(.editor)
                    .toolbar {
                        ToolbarItem(placement: .subtitle) {
                            Text("Pokémon")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        }
                        ToolbarItem {
                            Button {} label: { Image(systemName: "slider.horizontal.3") }
                        }
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
        .environmentObject(NavigationRouter())
}
