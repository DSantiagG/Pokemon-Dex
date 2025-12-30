//
//  PokemonHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.

import SwiftUI

struct PokemonHomeView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @StateObject private var pokemonVM = PokemonHomeViewModel(service: DataProvider.shared.pokemonService, layoutKey: .pokemon)
    
    @State private var showFilters = false
    
    var body: some View {
        NavigationContainer {
            content
                .toolbar { PokemonHomeToolbar(vm: pokemonVM, showFilters: $showFilters) }
                .sheet(isPresented: $showFilters) {
                    filterSheet
                }
        }
        .task {
            if pokemonVM.items.isEmpty {
                await pokemonVM.loadInitialPage()
            }
        }
        .alert( "Filters unavailable", isPresented: $pokemonVM.showFiltersError) {
            Button("Retry", role: .cancel) {
                Task { await pokemonVM.loadTypeResources() }
            }
        } message: {
            Text("We're having trouble loading filter data right now. Please try again later.")
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if case .notFound = pokemonVM.state {
            InfoStateView(
                primaryText: "No Pokémon found.",
                secondaryText: "Try adjusting your filters or check back later."
            )
        } else {
            pokemonList
                .animation(.smooth(duration: 0.2), value: pokemonVM.browseMode)
                .task {
                    await pokemonVM.refreshIfNeededOnAppear()
                }
        }
    }
    
    private var pokemonList: some View {
        ScrollView {
            ViewStateHandler(viewModel: pokemonVM) {
                PokemonList(
                    pokemons: pokemonVM.displayPokemons,
                    layout: pokemonVM.layout,
                    onItemAppear: { pokemon in
                        if pokemonVM.browseMode == .all {
                            Task {
                                await pokemonVM.loadNextPageIfNeeded(item: pokemon)
                            }
                        }
                    },
                    onItemSelected: { pokemonName in
                        router.push(.pokemonDetail(name: pokemonName))
                    })
            }
            .padding(.horizontal)
        }
    }
    
    private var filterSheet: some View {
        PokemonFilterView(allTypes: pokemonVM.displayTypes, selectedTypes: $pokemonVM.selectedTypes) {
            Task { await pokemonVM.filterPokemons() }
        }
        .presentationDetents([.medium])
        .presentationBackground(Color(.systemBackground))
        .presentationDragIndicator(.visible)
    }
}

private struct PokemonHomeToolbar: ToolbarContent {
    
    @ObservedObject var vm: PokemonHomeViewModel
    @Binding var showFilters: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .subtitle) {
            CustomTitle(title: AppTab.pokemon.title)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            PresentationOptionsMenu(layout: $vm.layout)
        }
        
        ToolbarSpacer(.fixed, placement: .topBarTrailing)
        
        if vm.browseMode != .filteredByTypes {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Favorites", systemImage: vm.browseMode == .favorites ? "heart.fill" : "heart") {
                    withAnimation(.smooth(duration: 0.15)) {
                        vm.toggleFavorites()
                    }
                }
            }
        }
        
        ToolbarSpacer(.fixed, placement: .topBarTrailing)
        
        if vm.browseMode != .favorites {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Filter", systemImage: "line.3.horizontal.decrease") {
                    showFilters = true
                }
            }
        }
    }
}

#Preview {
    PokemonHomeView()
        .environmentObject(NavigationRouter())
}
