//
//  ItemHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//

import SwiftUI

/// Root home view for the Items feature.
///
/// - Behavior:
///   - Uses a ``PaginationViewModel`` to load paged items.
///   - Shows ``InfoStateView`` when no items are available.
///   - Renders ``ItemList`` and exposes presentation controls in the toolbar.
struct ItemHomeView: View {
    
    // MARK: - Environment
    /// Router for handling navigation to item details.
    @EnvironmentObject private var router: NavigationRouter
    
    // MARK: - ViewModel
    /// ViewModel responsible for loading and paginating items, as well as managing layout preferences.
    @StateObject private var itemVM = PaginationViewModel(service: DataProvider.shared.itemService, layoutKey: .item)
    
    // MARK: - View
    
    var body: some View {
        NavigationContainer {
            Group{
                if case .notFound = itemVM.state {
                    InfoStateView(primaryText: "No Items found.", secondaryText: "There are currently no items.")
                }else{
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
                }
            }
            .toolbarRole(.editor)
            .toolbar {
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .subtitle) {
                        CustomTitle(title: AppTab.items.title)
                    }
                } else {
                    ToolbarItem(placement: .principal) {
                        CustomTitle(title: AppTab.items.title)
                    }
                }
                ToolbarItem {
                    PresentationOptionsMenu(layout: $itemVM.layout)
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
