//
//  SearchView.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/12/25.
//

import SwiftUI

struct SearchView: View {
    
    let searchTarget: AppTab
    @State private var searchText: String = ""
    @State var isSearchFocused: Bool?
    
    @State private var searchTask: Task<Void, Never>?
    
    var onDismissSearch: (() -> Void)
    
    var body: some View {
        NavigationContainer{
            Group {
                content
            }
            .navigationBarTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
        .searchable(
            text: $searchText,
            isPresented: Binding( get: { isSearchFocused ?? false }, set: { new in isSearchFocused = new }),
            placement: .automatic)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .onAppear{
            searchText = ""
            isSearchFocused = nil
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 70_000_000)
                isSearchFocused = true
            }
        }
        .onChange(of: isSearchFocused) { old, new in
            if old == true && new == false && searchText.isEmpty {
                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    onDismissSearch()
                }
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch searchTarget {
        case .pokemon: PokemonSearch(searchText: $searchText)
        case .abilities: AbilitySearch(searchText: $searchText)
        case .berries: Text("Berry Search")
        case .search: EmptyView()
        }
    }
}

#Preview {
    SearchView(searchTarget: .abilities){}
        .environmentObject(NavigationRouter())
}
