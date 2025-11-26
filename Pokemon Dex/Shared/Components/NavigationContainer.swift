//
//  NavigationContainer.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//
import SwiftUI

struct NavigationContainer<Content: View>: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    private let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        NavigationStack (path: $router.path){
            content()
                .navigationDestination(for: NavigationRouter.AppRoute.self) { route in
                    switch route{
                    case .pokemonDetail(name: let name):
                        PokemonDetailView(pokemonName: name)
                    case .abilityDetail(name: let name):
                        AbilityDetailView(abilityName: name)
                    }
                }
        }
    }
}

#Preview {
    NavigationContainer{
        EmptyView()
    }
    .environmentObject(NavigationRouter())
}
