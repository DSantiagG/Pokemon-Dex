//
//  MainTabView.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var appRouter = AppRouter()
    
    @State private var selection: TabKey = .pokemon
    @State private var lastPrimarySelection: TabKey = .pokemon
    @State private var searchTarget: TabKey = .pokemon
    
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
            
            Tab("Pokémon", systemImage: "circle.circle.fill", value: TabKey.pokemon) {
                PokemonHomeView()
                    .environmentObject(appRouter.pokemonRouter)
            }
            
            Tab("Abilities", systemImage: "bolt.circle.fill", value: TabKey.abilities) {
                AbilityHomeView()
                    .environmentObject(appRouter.abilityRouter)
            }
            
            Tab("Berries", systemImage: "leaf.circle.fill", value: TabKey.berries) {
                InfoStateView(primaryText: "This feature is still under construction.", secondaryText: "Please check back soon!")
            }
            
            Tab(value: TabKey.search, role: .search) {
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
