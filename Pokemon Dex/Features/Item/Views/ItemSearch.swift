//
//  ItemSearch.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//

import SwiftUI

/// Search UI for items used inside the feature's search tab.
///
/// - Parameters:
///   - searchText: Binding to the parent search input shared by `SearchView`.
///
/// Behavior:
/// - Debounces and performs searches through ``SearchViewModel``.
/// - Shows ``InfoStateView`` when the query is empty or when no results are found.
struct ItemSearch: View {
    
    // MARK: - Environment
    /// Router for handling navigation to item details when a search result is selected.
    @EnvironmentObject private var router: NavigationRouter
    
    // MARK: - ViewModel
    /// ViewModel responsible for performing item searches and exposing results and state.
    @StateObject private var itemVM = SearchViewModel(service: DataProvider.shared.itemService)
    
    // MARK: - Parameters
    
    @Binding var searchText: String
    
    // MARK: - View
    
    var body: some View {
        Group {
            if searchText.isEmpty {
                InfoStateView(primaryText: "Start your search",
                              secondaryText: "Type an item name to find it.")
                .padding(.bottom, 80)
            }else if case .notFound = itemVM.state {
                InfoStateView(primaryText: "No item found", secondaryText: "Try a different name or check your spelling.")
                    .padding(.bottom, 80)
            }else {
                ScrollView {
                    ViewStateHandler(viewModel: itemVM) {
                        ItemList(items: itemVM.results, layout: .singleColumn, onItemSelected: {
                            itemName in
                            router.push(.itemDetail(name: itemName))
                        })
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            itemVM.search(newValue)
        }
    }
}

#Preview {
    ItemSearch(searchText: .constant(""))
        .environmentObject(NavigationRouter())
}
