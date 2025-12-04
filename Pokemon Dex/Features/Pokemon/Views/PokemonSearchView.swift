//
//  PokemonSearchView.swift
//  Pokemon Dex
//
//  Created by David Giron on 20/11/25.
//
import SwiftUI
import PokemonAPI

struct PokemonSearchView: View {
    
    @StateObject private var pokemonVM = PokemonSearchViewModel(pokemonService: DataProvider.shared.pokemonService)
    
    @EnvironmentObject private var router: NavigationRouter
    @State private var isSearchFocused: Bool = true
    
    var onDismissSearch: (() -> Void)
    
    var body: some View {
        
        NavigationContainer{
            Group {
                if pokemonVM.searchText.isEmpty {
                    InfoStateView(primaryText: "Start your search",
                                  secondaryText: "Type a Pokémon name to find it.")
                    .padding(.bottom, 80)
                }else if case .notFound = pokemonVM.state {
                    InfoStateView(primaryText: "No Pokémon found", secondaryText: "Try a different name or check your spelling.")
                        .padding(.bottom, 80)
                }else {
                    ScrollView {
                        ViewStateHandler(viewModel: pokemonVM) {
                            PokemonList(pokemons: pokemonVM.filteredPokemons, layout: .singleColumn)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
            .searchable(text: $pokemonVM.searchText, isPresented: $isSearchFocused)
            .searchPresentationToolbarBehavior(.avoidHidingContent)
        }
        .onAppear{
            isSearchFocused = true
        }
        .onChange(of: isSearchFocused) { _, focused in
            if !focused, pokemonVM.searchText.isEmpty {
                onDismissSearch()
            }
        }
    }
}

#Preview {
    PokemonSearchView{}
        .environmentObject(NavigationRouter())
}
