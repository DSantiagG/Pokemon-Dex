//
//  MainTabView.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var appRouter = AppRouter()
    @StateObject private var dataProvider = DataProvider()
    
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
            NavigationContainerView{
                ViewStateView<PokemonViewModel, PokemonListView> {
                    PokemonListView()
                }
            }
                .environmentObject(appRouter.pokemonRouter)
                .environmentObject(dataProvider.pokemonViewModel)
                .tabItem {
                    Label("Pokémon", systemImage: "bolt.circle.fill")
                }
            
            //AbilityHomeView()
            NavigationContainerView{
                ViewStateView<PokemonViewModel, PokemonListView> {
                    PokemonListView()
                }
            }
                .environmentObject(appRouter.abilityRouter)
                .environmentObject(dataProvider.pokemonViewModel)
                .tabItem {
                    Label("Abilities", systemImage: "star.circle.fill")
                }
            
            //BerryHomeView()
            NavigationContainerView{
                ViewStateView<PokemonViewModel, PokemonListView> {
                    PokemonListView()
                }
            }
                .environmentObject(appRouter.pokemonRouter)
                .environmentObject(dataProvider.pokemonViewModel)
                .tabItem {
                    Label("Berries", systemImage: "leaf.circle.fill")
                }
            
            //LocationHomeView()
            NavigationContainerView{
                ViewStateView<PokemonViewModel, PokemonListView> {
                    PokemonListView()
                }
            }
                .environmentObject(appRouter.pokemonRouter)
                .environmentObject(dataProvider.pokemonViewModel)
                .tabItem {
                    Label("Places", systemImage: "map.circle.fill")
                }
        }
    }
    
}

#Preview ("main"){
    MainTabView()
}

