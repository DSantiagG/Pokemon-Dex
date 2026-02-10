//
//  PokemonSearch.swift
//  Pokemon Dex
//
//  Created by David Giron on 20/11/25.
//
import SwiftUI
import PokemonAPI

/// Search view used within the app's search tab/flow.
///
/// - Parameters:
///   - searchText: Binding to the current search query controlled by the parent view.
///
/// - Behavior:
///   The view observes `searchText` and forwards changes to the `SearchViewModel.search(_:)` method.
///   It shows an `InfoStateView` when the query is empty or when the view model reports `.notFound`,
///   otherwise it displays results in a `PokemonList` and navigates to details when an item is selected.
struct PokemonSearch: View {
    
    // MARK: - Environment
    /// Required to navigate to the Pokémon detail screen when a search result is selected.
    @EnvironmentObject private var router: NavigationRouter
    
    // MARK: - ViewModel
    /// Performs the search and exposes `results` and `state` for the UI.
    @StateObject private var pokemonVM = SearchViewModel(service: DataProvider.shared.pokemonService)
    
    // MARK: - Properties
    @Binding var searchText: String
    
    // MARK: - Body
    var body: some View {
        Group {
            // Empty query: prompt the user to start typing
            if searchText.isEmpty {
                InfoStateView(primaryText: "Start your search",
                              secondaryText: "Type a Pokémon name to find it.")
                .padding(.bottom, 80)
            // No results found for the query
            }else if case .notFound = pokemonVM.state {
                InfoStateView(primaryText: "No Pokémon found", secondaryText: "Try a different name or check your spelling.")
                    .padding(.bottom, 80)
            // Results available: show list and allow navigation
            }else {
                ScrollView {
                    ViewStateHandler(viewModel: pokemonVM) {
                        PokemonList(pokemons: pokemonVM.results, layout: .singleColumn, onItemSelected:  { pokemonName in
                            // Navigate to detail when an item is selected
                            router.push(.pokemonDetail(name: pokemonName))
                        })
                    }
                    .padding(.horizontal)
                }
            }
        }
        // Forward query changes to the view model (debounce handled by SearchViewModel)
        .onChange(of: searchText) { _, newValue in
            pokemonVM.search(newValue)
        }
    }
}

#Preview {
    PokemonSearch(searchText: .constant(""))
        .environmentObject(NavigationRouter())
}
