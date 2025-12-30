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
    @State private var selectedTypes: [String] = []
    
    var body: some View {
        NavigationContainer {
            Group{
                if case .notFound = pokemonVM.state {
                    InfoStateView(primaryText: "No Pokémon found.", secondaryText: "Try adjusting your filters or check back later.")
                }else{
                    ScrollView {
                        ViewStateHandler(viewModel: pokemonVM) {
                            if case .loading = pokemonVM.state, !selectedTypes.isEmpty {
                                EmptyView()
                            }else {
                                PokemonList(
                                    pokemons: pokemonVM.showFilteredResults ? pokemonVM.filteredPokemons : pokemonVM.items,
                                    layout: pokemonVM.layout,
                                    onItemAppear: { pokemon in
                                        if !pokemonVM.showFilteredResults {
                                            Task {
                                                await pokemonVM.loadNextPageIfNeeded(item: pokemon)
                                            }
                                        }
                                    },
                                    onItemSelected: { pokemonName in
                                        router.push(.pokemonDetail(name: pokemonName))
                                    })
                            }
                        }
                        .padding(.horizontal)
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .subtitle) {
                    CustomTitle(title: AppTab.pokemon.title)
                }
                ToolbarItem (placement: .topBarTrailing) {
                    PresentationOptionsMenu( layout: $pokemonVM.layout)
                }
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                ToolbarItem (placement: .topBarTrailing) {
                    Button("Filter", systemImage: "line.3.horizontal.decrease") {
                        showFilters = true
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                PokemonFilterView(allTypes: pokemonVM.displayTypes, selectedTypes: $selectedTypes) {
                    Task { await pokemonVM.filterPokemons(byTypes: selectedTypes) }
                }
                .presentationDetents([.medium])
                .presentationBackground(Color(.systemBackground))
                .presentationDragIndicator(.visible)
            }
        }
        .task {
            if pokemonVM.items.isEmpty {
                await pokemonVM.loadInitialPage()
            }
        }
        .alert(
            "Filters unavailable",
            isPresented: $pokemonVM.showFiltersError
        ) {
            Button("Retry", role: .cancel) {
                Task { await pokemonVM.loadTypeResources() }
            }
        } message: {
            Text("We're having trouble loading filter data right now. Please try again later.")
        }
    }
}

#Preview {
    PokemonHomeView()
        .environmentObject(NavigationRouter())
}
