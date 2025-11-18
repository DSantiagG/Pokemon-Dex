//
//  PokemonHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

struct PokemonHomeView: View {
    
    @StateObject private var pokemonVM = PokemonViewModel(pokemonService: DataProvider.shared.pokemonService)
    
    var body: some View {
        Group{
            if case .loaded = pokemonVM.state, pokemonVM.pokemons.isEmpty {
                InfoStateView(primaryText: "No Pokémon found.", secondaryText: "Try catching some first!")
            }else{
                NavigationContainerView{
                    ScrollView {
                        VStack{
                            Text("Pokémon Dex")
                                .font(.system(size: 36, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                                .shadow(color: .red.opacity(0.4), radius: 1)
                            
                            ViewStateView(viewModel: pokemonVM) {
                                PokemonListView()
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .environmentObject(pokemonVM)
        .task {
            if pokemonVM.pokemons.isEmpty {
                await pokemonVM.loadInitialPage()
            }
        }
    }
}

#Preview {
    PokemonHomeView()
        .environmentObject(PokemonViewModel(pokemonService: PokemonService()))
        .environmentObject(NavigationRouter())
}
