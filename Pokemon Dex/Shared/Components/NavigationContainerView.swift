//
//  NavigationContainerView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//
import SwiftUI

struct NavigationContainerView<Content: View>: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    private let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        NavigationStack (path: $router.path){
            ScrollView {
                Text("Pokémon Dex")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .shadow(color: .red.opacity(0.4), radius: 4)
                
                content()
                    .padding(.horizontal)
            }
            .navigationDestination(for: NavigationRouter.Route.self) { route in
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
    NavigationContainerView{
        EmptyView()
    }
    .environmentObject(NavigationRouter())
    .environmentObject(PokemonViewModel())
}
