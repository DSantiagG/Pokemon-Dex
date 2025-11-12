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
    
    var body: some View {
        TabView {
            // MARK: Pokémon Tab
            PokemonHomeView()
                .environmentObject(appRouter.pokemonRouter)
                .environmentObject(dataProvider.pokemonViewModel)
            .tabItem {
                Label("Pokémon", systemImage: "bolt.circle.fill")
            }
            
            // MARK: Abilities Tab
            
            //AbilityHomeView()
            PokemonHomeView()
                .environmentObject(appRouter.pokemonRouter)
                .environmentObject(dataProvider.pokemonViewModel)
            .tabItem {
                Label("Abilities", systemImage: "star.circle.fill")
            }
            
            // MARK: Berries Tab
            
            //BerryHomeView()
            PokemonHomeView()
                .environmentObject(appRouter.pokemonRouter)
                .environmentObject(dataProvider.pokemonViewModel)
            .tabItem {
                Label("Berries", systemImage: "leaf.circle.fill")
            }
            
            // MARK: Locations Tab
            
            //LocationHomeView()
            PokemonHomeView()
                .environmentObject(appRouter.pokemonRouter)
                .environmentObject(dataProvider.pokemonViewModel)
            .tabItem {
                Label("Places", systemImage: "map.circle.fill")
            }
        }
        .tint(.red)
    }
}

#Preview {
    MainTabView()
}

