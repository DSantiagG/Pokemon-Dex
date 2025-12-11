//
//  AbilitySearch.swift
//  Pokemon Dex
//
//  Created by David Giron on 5/12/25.
//

import SwiftUI

struct AbilitySearch: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @StateObject private var abilityVM = SearchViewModel(service: DataProvider.shared.abilityService)
    
    @Binding var searchText: String
    
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
        .onChange(of: searchText) { _, newValue in
            abilityVM.search(newValue)
        }
    }
}

#Preview {
    AbilitySearch(searchText: .constant(""))
        .environmentObject(NavigationRouter())
}
