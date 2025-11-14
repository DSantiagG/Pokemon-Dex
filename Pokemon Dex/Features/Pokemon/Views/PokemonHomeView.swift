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
