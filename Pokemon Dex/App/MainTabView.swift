//
//  MainTabView.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    private enum TabKey: Hashable {
        case pokemon, abilities, berries, search
    }
    
    @StateObject var appRouter = AppRouter()
    
    @State private var selection: TabKey = .pokemon
    @State private var lastPrimarySelection: TabKey = .pokemon
    
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
            
            /*
             Tab("Berries", systemImage: "leaf.circle.fill", value: TabKey.berries) {
                 InfoStateView(primaryText: "This feature is still under construction.", secondaryText: "Please check back soon!")
             }
             */
            
            Tab(value: TabKey.search, role: .search) {
                searchContainerView
            }
        }
        .onChange(of: selection) { _ , newValue in
            switch newValue {
            case .pokemon, .abilities, .berries:
                lastPrimarySelection = newValue
            case .search:
                break
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
    
    
    var searchContainerView: some View {
        Group{
            switch lastPrimarySelection {
            case .pokemon:
                PokemonSearchView{
                    selection = lastPrimarySelection
                }
                .environmentObject(appRouter.pokemonSearchRouter)
            case .abilities:
                InfoStateView(primaryText: "This feature is still under construction.", secondaryText: "Please check back soon!")
            case .berries:
                InfoStateView(primaryText: "This feature is still under construction.", secondaryText: "Please check back soon!")
            case .search:
                EmptyView()
            }
        }
    }
}

#Preview{
    MainTabView()
}
