//
//  PokemonHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.

import SwiftUI

/// Root home view that shows a browsable list of Pokémon and provides access to
/// filters, favorites and presentation options.
struct PokemonHomeView: View {
    
    // MARK: - Environment
    /// Router used for navigation actions, injected from the parent view.
    @EnvironmentObject private var router: NavigationRouter
    
    // MARK: - StateObject
    /// View model that provides paginated pokémon data and filtering behavior.
    @StateObject private var pokemonVM = PokemonHomeViewModel(service: DataProvider.shared.pokemonService, layoutKey: .pokemon)
    
    // MARK: - State
    /// Controls whether the filter sheet is presented.
    @State private var showFilters = false
    
    // MARK: - Body
    var body: some View {
        NavigationContainer {
            content
                .toolbar { PokemonHomeToolbar(vm: pokemonVM, showFilters: $showFilters) }
                .sheet(isPresented: $showFilters) {
                    filterSheet
                }
        }
        .task {
            // Perform initial load only when items are empty (prevents reload on small view updates)
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
    
    // MARK: - Content (computed view)
    /// View that switches between an `InfoStateView` when no pokémon are found and the main list content otherwise.
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
    
    // MARK: - Main list
    /// Scrollable list of pokémon that wires the view model's data, layout and pagination behavior to `PokemonList`.
    private var pokemonList: some View {
        ScrollView {
            ViewStateHandler(viewModel: pokemonVM) {
                PokemonList(
                    pokemons: pokemonVM.displayPokemons,
                    layout: pokemonVM.layout,
                    onItemAppear: { pokemon in
                        // Trigger pagination only when browsing all items
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
    
    // MARK: - Filter sheet
    /// Sheet view that presents type filters and applies them via the view model.
    private var filterSheet: some View {
        PokemonFilterView(allTypes: pokemonVM.displayTypes, selectedTypes: $pokemonVM.selectedTypes) {
            Task { await pokemonVM.filterPokemons() }
        }
        .presentationDetents([.medium])
        .presentationBackground(Color(.systemBackground))
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Toolbar

/// Toolbar content used by `PokemonHomeView`.
///
/// - Parameters:
///   - vm: The `PokemonHomeViewModel` that supplies state and actions used by the toolbar.
///   - showFilters: Binding to the view's `showFilters` state to present the filter sheet.
private struct PokemonHomeToolbar: ToolbarContent {
    
    // MARK: - Observed / Bindings
    @ObservedObject var vm: PokemonHomeViewModel
    @Binding var showFilters: Bool
    
    // MARK: - Body
    var body: some ToolbarContent {
        ToolbarItem(placement: .subtitle) {
            CustomTitle(title: AppTab.pokemon.title)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            PresentationOptionsMenu(layout: $vm.layout)
        }
        
        ToolbarSpacer(.fixed, placement: .topBarTrailing)
        
        // Favorites button: hidden when filteredByTypes to avoid conflicting modes
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
        
        // Filter button: hidden when viewing favorites
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
