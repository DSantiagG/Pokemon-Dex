//
//  ItemHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//

import SwiftUI

struct ItemHomeView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @StateObject private var itemVM = PaginationViewModel(service: DataProvider.shared.itemService, layoutKey: .item)
    
    var body: some View {
        Group{
            if case .notFound = itemVM.state {
                InfoStateView(primaryText: "No Items found.", secondaryText: "There are currently no items.")
            }else{
                NavigationContainer {
                    ScrollView {
                        ViewStateHandler(viewModel: itemVM) {
                            ItemList(
                                items: itemVM.items,
                                layout: itemVM.layout,
                                onItemAppear: { item in
                                    Task { await itemVM.loadNextPageIfNeeded(item: item) }
                                },
                                onItemSelected: { itemName in
                                    router.push(.itemDetail(name: itemName))
                                })
                        }
                        .padding(.horizontal)
                    }
                    .toolbarRole(.editor)
                    .toolbar {
                        ToolbarItem(placement: .subtitle) {
                            CustomTitle(title: AppTab.items.title)
                        }
                        ToolbarItem {
                            PresentationOptionsMenu(layout: $itemVM.layout)
                        }
                    }
                }
            }
        }
        .task {
            if itemVM.items.isEmpty {
                await itemVM.loadInitialPage()
            }
        }
    }
}

#Preview {
    ItemHomeView()
        .environmentObject(NavigationRouter())
}
