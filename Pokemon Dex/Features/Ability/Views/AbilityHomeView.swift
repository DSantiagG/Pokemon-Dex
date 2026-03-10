//
//  AbilityHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 3/12/25.
//

import SwiftUI

/// Home screen listing abilities with pagination and presentation options.
///
/// - Behavior:
///   - Uses a ``PaginationViewModel`` to load paged ability items.
///   - Shows ``InfoStateView`` when no abilities are available.
///   - Renders ``AbilityList`` and exposes presentation controls in the toolbar.
struct AbilityHomeView: View {
    
    // MARK: - Environment
    /// Router used for navigation actions.
    @EnvironmentObject private var router: NavigationRouter
    
    // MARK: - View Model
    /// Pagination view model for loading and paging ability items.
    @StateObject private var abilityVM = PaginationViewModel(service: DataProvider.shared.abilityService, layoutKey: .ability)
    
    // MARK: - Body
    var body: some View {
        NavigationContainer {
            Group{
                if case .notFound = abilityVM.state {
                    InfoStateView(primaryText: "No Abilities found.", secondaryText: "There are currently no abilities.")
                }else{
                    ScrollView {
                        ViewStateHandler(viewModel: abilityVM) {
                            AbilityList(
                                abilities: abilityVM.items,
                                layout: abilityVM.layout,
                                onItemAppear: { ability in
                                    Task { await abilityVM.loadNextPageIfNeeded(item: ability) }
                                },
                                onItemSelected: { abilityName in
                                    router.push(.abilityDetail(name: abilityName))
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
                        CustomTitle(title: AppTab.abilities.title)
                    }
                } else {
                    ToolbarItem(placement: .principal) {
                        CustomTitle(title: AppTab.abilities.title)
                    }
                }
                ToolbarItem {
                    PresentationOptionsMenu(layout: $abilityVM.layout)
                }
            }
        }
        .task {
            if abilityVM.items.isEmpty {
                await abilityVM.loadInitialPage()
            }
        }
    }
}

#Preview {
    AbilityHomeView()
        .environmentObject(NavigationRouter())
}
