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
                NavigationContainerView{
                    ScrollView {
                        VStack{
                            Text("Pokémon")
                                .font(.system(size: 36, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .shadow(color: .red.opacity(0.4), radius: 0.5)
                            
                            ViewStateView(viewModel: pokemonVM) {
                                PokemonListView(pokemons: pokemonVM.pokemons, onItemAppear: { pokemon in
                                    Task { await pokemonVM.loadNextPageIfNeeded(pokemon: pokemon) }
                                })
                            }
                        }
                        .padding(.horizontal)
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
