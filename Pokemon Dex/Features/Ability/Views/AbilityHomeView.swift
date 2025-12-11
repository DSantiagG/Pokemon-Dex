//
//  AbilityHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 3/12/25.
//

import SwiftUI

struct AbilityHomeView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @StateObject private var abilityVM = PaginationViewModel(service: DataProvider.shared.abilityService)
    
    var body: some View {
        Group{
            if case .notFound = abilityVM.state {
                InfoStateView(primaryText: "No Abilities found.", secondaryText: "There are currently no abilities.")
            }else{
                NavigationContainer {
                    ScrollView {
                        ViewStateHandler(viewModel: abilityVM) {
                            AbilityList(
                                abilities: abilityVM.items,
                                onItemAppear: { ability in
                                    Task { await abilityVM.loadNextPageIfNeeded(item: ability) }
                                },
                                onItemSelected: { abilityName in
                                    router.push(.abilityDetail(name: abilityName))
                                })
                        }
                        .padding(.horizontal)
                    }
                    .toolbarRole(.editor)
                    .toolbar {
                        ToolbarItem(placement: .subtitle) {
                            Text(AppTab.abilities.title)
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        }
                        ToolbarItem {
                            Color.clear.frame(width: 0, height: 0)
                        }
                    }
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
