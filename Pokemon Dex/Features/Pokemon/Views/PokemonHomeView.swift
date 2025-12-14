//
//  PokemonHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

struct PokemonHomeView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @StateObject private var pokemonVM = PokemonHomeViewModel(service: DataProvider.shared.pokemonService, layoutKey: .pokemon)
    
    @State private var showFilters = false

    var body: some View {
        Group{
            if case .notFound = pokemonVM.state {
                InfoStateView(primaryText: "No Pokémon found.", secondaryText: "Try catching some first!")
            }else{
                NavigationContainer {
                    ScrollView {
                        ViewStateHandler(viewModel: pokemonVM) {
                            PokemonList(
                                pokemons: pokemonVM.items,
                                layout: pokemonVM.layout,
                                onItemAppear: { pokemon in
                                    Task { await pokemonVM.loadNextPageIfNeeded(item: pokemon) }
                                },
                                onItemSelected: { pokemonName in
                                    router.push(.pokemonDetail(name: pokemonName))
                                })
                        }
                        .padding(.horizontal)
                    }
                    .toolbarRole(.editor)
                    .toolbar {
                        ToolbarItem(placement: .subtitle) {
                            CustomTitle(title: AppTab.pokemon.title)
                        }
                        ToolbarItem {
                            PresentationOptionsMenu(
                                layout: $pokemonVM.layout,
                                showsFilters: true) {
                                showFilters = true
                            }
                        }
                    }
                    .sheet(isPresented: $showFilters) {
                        Text("Filters coming soon 👀")
                            .presentationDetents([.medium])
                            .presentationBackground(Color(.systemBackground))
                            .presentationDragIndicator(.visible)
                    }
                }
            }
        }
        .task {
            if pokemonVM.items.isEmpty {
                await pokemonVM.loadInitialPage()
            }
        }
    }
}

#Preview {
    PokemonHomeView()
        .environmentObject(NavigationRouter())
}
