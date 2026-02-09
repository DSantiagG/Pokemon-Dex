//
//  SearchView.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/12/25.
//

import SwiftUI

/// Screen that presents a searchable UI and delegates the actual search UI
/// to the feature-specific search views for the selected `searchTarget`.
///
/// - Parameters:
///   - searchTarget: The `AppTab` that determines which feature's search UI to show.
///   - onDismissSearch: Closure called when the search UI is dismissed without a query.
///
/// Example:
/// ```swift
/// SearchView(searchTarget: .pokemon) { /* dismissed */ }
/// ```
struct SearchView: View {
    
    // MARK: - Parameters
    
    /// Which feature/tab to target for searching (Pokémon, Abilities, Items, etc.).
    let searchTarget: AppTab
    /// Called when the search sheet is dismissed while the query is empty.
    var onDismissSearch: (() -> Void)
    
    // MARK: - State
    
    /// The current search query bound to the system `searchable` field.
    @State private var searchText: String = ""
    
    /// Optional focus state for the search field. `nil` is used as an initial
    /// unknown state; the view converts this to a `Binding<Bool>` for `searchable`.
    @State private var isSearchFocused: Bool?
    
    
    // MARK: - Body
    
    var body: some View {
        NavigationContainer{
            Group {
                content
            }
            .navigationBarTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
        // Provide a binding that adapts the optional focus state to the Bool
        // required by `.searchable(isPresented:)`.
        .searchable(
            text: $searchText,
            isPresented: Binding(
                get: { isSearchFocused ?? false },
                set: { new in isSearchFocused = new }
            ),
            placement: .automatic)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .onAppear{
            // Reset and then request focus after a short delay so the search
            // field reliably becomes first responder when appropriate.
            searchText = ""
            isSearchFocused = nil
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 70_000_000)
                isSearchFocused = true
            }
        }
        .onChange(of: isSearchFocused) { old, new in
            // If the user had the search presented and then dismissed it while
            // the query is empty, notify the caller after a short delay to allow
            // the UI to finish the dismissal animation.
            if old == true && new == false && searchText.isEmpty {
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    onDismissSearch()
                }
            }
        }
    }
    
    // MARK: - Content
    
    /// Returns the feature-specific search view for the current `searchTarget`.
    ///
    /// This computed property switches on `searchTarget` and returns the
    /// corresponding view, wiring the shared `searchText` binding into the
    /// feature's search component.
    @ViewBuilder
    var content: some View {
        switch searchTarget {
        case .pokemon: PokemonSearch(searchText: $searchText)
        case .abilities: AbilitySearch(searchText: $searchText)
        case .items: ItemSearch(searchText: $searchText)
        case .search: EmptyView()
        }
    }
}

#Preview {
    SearchView(searchTarget: .abilities){}
        .environmentObject(NavigationRouter())
}
