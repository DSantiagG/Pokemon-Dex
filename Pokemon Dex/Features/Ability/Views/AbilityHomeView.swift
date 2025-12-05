//
//  AbilityHomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 3/12/25.
//

import SwiftUI

struct AbilityHomeView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    @StateObject private var abilityVM = AbilityHomeViewModel(abilityService: DataProvider.shared.abilityService)
    
    var body: some View {
        Group{
            if case .notFound = abilityVM.state {
                InfoStateView(primaryText: "No Abilities found.", secondaryText: "There are currently no abilities.")
            }else{
                NavigationContainer {
                    ScrollView {
                        ViewStateHandler(viewModel: abilityVM) {
                            AbilityList(
                                abilities: abilityVM.abilities,
                                onItemAppear: { ability in
                                    Task { await abilityVM.loadNextPageIfNeeded(ability: ability) }
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
                            Text("Abilities")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                )
                        }
                        ToolbarItem {
                            Button {} label: { Image(systemName: "slider.horizontal.3") }
                        }
                    }
                }
            }
        }
        .task {
            if abilityVM.abilities.isEmpty {
                await abilityVM.loadInitialPage()
            }
        }
    }
}

#Preview {
    AbilityHomeView()
        .environmentObject(NavigationRouter())
}
