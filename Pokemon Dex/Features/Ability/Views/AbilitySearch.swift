//
//  AbilitySearch.swift
//  Pokemon Dex
//
//  Created by David Giron on 5/12/25.
//

import SwiftUI

/// Search view for abilities.
///
/// - Parameters:
///   - searchText: Bound search string controlled by the parent ``SearchView``.
///
/// Behavior:
/// - Binds to `searchText`, drives a `SearchViewModel`, and shows results or info states.
struct AbilitySearch: View {
    
    // MARK: - Environment
    /// Router used for navigation actions.
    @EnvironmentObject private var router: NavigationRouter
    
    // MARK: - View Model
    /// View model that performs ability searches.
    @StateObject private var abilityVM = SearchViewModel(service: DataProvider.shared.abilityService)
    
    // MARK: - Bindings
    /// Bound search text entered by the user.
    @Binding var searchText: String
    
    // MARK: - Body
    var body: some View {
        Group {
            if searchText.isEmpty {
                InfoStateView(primaryText: "Start your search",
                              secondaryText: "Type an ability name to find it.")
                .padding(.bottom, 80)
            }else if case .notFound = abilityVM.state {
                InfoStateView(primaryText: "No Ability found", secondaryText: "Try a different name or check your spelling.")
                    .padding(.bottom, 80)
            }else {
                ScrollView {
                    ViewStateHandler(viewModel: abilityVM) {
                        AbilityList(abilities: abilityVM.results, color: .red, onItemSelected: {
                            abilityName in
                            router.push(.abilityDetail(name: abilityName))
                        })
                    }
                    .padding(.horizontal)
                }
            }
        }
        // MARK: - Reactions
        /// Trigger a search whenever the bound text changes.
        .onChange(of: searchText) { _, newValue in
            abilityVM.search(newValue)
        }
    }
}

#Preview {
    AbilitySearch(searchText: .constant(""))
        .environmentObject(NavigationRouter())
}
