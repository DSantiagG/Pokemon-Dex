//
//  MainTabView.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var appRouter = AppRouter()
    
    @State private var selection: AppTab = .pokemon
    @State private var lastPrimarySelection: AppTab = .pokemon
    @State private var searchTarget: AppTab = .pokemon
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .systemRed
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemRed]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        
        TabView (selection: $selection){
            
            Tab(AppTab.pokemon.title, systemImage: AppTab.pokemon.systemImageName, value: AppTab.pokemon) {
                PokemonHomeView()
                    .environmentObject(appRouter.pokemonRouter)
            }
            
            Tab(AppTab.abilities.title, systemImage: AppTab.abilities.systemImageName, value: AppTab.abilities) {
                AbilityHomeView()
                    .environmentObject(appRouter.abilityRouter)
            }
            
            Tab(AppTab.berries.title, systemImage: AppTab.berries.systemImageName, value: AppTab.berries) {
                InfoStateView(primaryText: "This feature is still under construction.", secondaryText: "Please check back soon!")
            }
            
            Tab(value: AppTab.search, role: .search) {
                SearchView(searchTarget: searchTarget) {
                    selection = searchTarget
                }
                .environmentObject(routerForCurrentTarget())
            }
        }
        .onChange(of: selection) { _ , newValue in
            if newValue == .search {
                searchTarget = lastPrimarySelection
            } else {
                lastPrimarySelection = newValue
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
    
    private func routerForCurrentTarget() -> NavigationRouter {
        switch searchTarget {
        case .pokemon: return appRouter.pokemonSearchRouter
        case .abilities: return appRouter.abilitySearchRouter
        case .berries: return appRouter.berrySearchRouter
        default: return appRouter.pokemonSearchRouter
        }
    }
}

#Preview{
    MainTabView()
}
