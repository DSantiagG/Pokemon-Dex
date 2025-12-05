//
//  AbilitySearchView.swift
//  Pokemon Dex
//
//  Created by David Giron on 5/12/25.
//

import SwiftUI

struct AbilitySearchView: View {
    
    @StateObject private var abilityVM = AbilitySearchViewModel(abilityService: DataProvider.shared.abilityService)
    
    @EnvironmentObject private var router: NavigationRouter
    @State private var isSearchFocused: Bool = false
    
    var onDismissSearch: (() -> Void)
    
    var body: some View {
        NavigationContainer{
            Group {
                if abilityVM.searchText.isEmpty {
                    InfoStateView(primaryText: "Start your search",
                                  secondaryText: "Type an ability name to find it.")
                    .padding(.bottom, 80)
                }else if case .notFound = abilityVM.state {
                    InfoStateView(primaryText: "No Ability found", secondaryText: "Try a different name or check your spelling.")
                        .padding(.bottom, 80)
                }else {
                    ScrollView {
                        ViewStateHandler(viewModel: abilityVM) {
                            AbilityList(abilities: abilityVM.filteredAbilities, color: .red, onItemSelected: {
                                abilityName in
                                router.push(.abilityDetail(name: abilityName))
                            })
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarTitle("Search")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
        .searchable(text: $abilityVM.searchText, isPresented: $isSearchFocused, placement: .automatic)
        .searchPresentationToolbarBehavior(.avoidHidingContent)
        .onAppear{
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 50_000_000)
                isSearchFocused = true
            }
        }
        .onChange(of: isSearchFocused) { _, focused in
            if !focused, abilityVM.searchText.isEmpty {
                onDismissSearch()
            }
        }
    }
}

#Preview {
    AbilitySearchView{}
        .environmentObject(NavigationRouter())
}
