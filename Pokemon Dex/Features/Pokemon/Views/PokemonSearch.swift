//
//  PokemonSearch.swift
//  Pokemon Dex
//
//  Created by David Giron on 20/11/25.
//
import SwiftUI
import PokemonAPI

struct PokemonSearch: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @StateObject private var pokemonVM = SearchViewModel(service: DataProvider.shared.pokemonService)
    
    @Binding var searchText: String
    
    var body: some View {
        Group {
            if searchText.isEmpty {
                InfoStateView(primaryText: "Start your search",
                              secondaryText: "Type a Pokémon name to find it.")
                .padding(.bottom, 80)
            }else if case .notFound = pokemonVM.state {
                InfoStateView(primaryText: "No Pokémon found", secondaryText: "Try a different name or check your spelling.")
                    .padding(.bottom, 80)
            }else {
                ScrollView {
                    ViewStateHandler(viewModel: pokemonVM) {
                        PokemonList(pokemons: pokemonVM.results, layout: .singleColumn, onItemSelected:  { pokemonName in
                            router.push(.pokemonDetail(name: pokemonName))
                        })
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            pokemonVM.search(newValue)
        }
    }
}

#Preview {
    PokemonSearch(searchText: .constant(""))
        .environmentObject(NavigationRouter())
}
