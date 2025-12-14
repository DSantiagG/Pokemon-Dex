//
//  ItemSearch.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//

import SwiftUI

struct ItemSearch: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @StateObject private var itemVM = SearchViewModel(service: DataProvider.shared.itemService)
    
    @Binding var searchText: String
    
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
