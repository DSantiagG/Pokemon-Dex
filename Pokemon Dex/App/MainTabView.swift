//
//  MainTabView.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var appRouter = AppRouter()
    
    @State var text = ""
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .systemRed
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemRed]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        
        TabView {
            PokemonHomeView()
                .environmentObject(appRouter.pokemonRouter)
                .tabItem {
                    Label("Pokémon", systemImage: "bolt.circle.fill")
                }
            
             InfoStateView(primaryText: "This feature is still under construction.", secondaryText: "Please check back soon!")
                .tabItem {
                    Label("Abilities", systemImage: "star.circle.fill")
                }
            
            InfoStateView(primaryText: "This feature is still under construction.", secondaryText: "Please check back soon!")
                .tabItem {
                    Label("Berries", systemImage: "leaf.circle.fill")
                }
        }
    }
}

#Preview ("main"){
    MainTabView()
}
