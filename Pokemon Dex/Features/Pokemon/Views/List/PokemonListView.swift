//
//  PokemonListView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

enum ListLayout {
    case twoColumns
    case singleColumn
}

struct PokemonListView: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    let pokemons: [PKMPokemon]
    var layout: ListLayout = .twoColumns
    
    var onItemAppear: (PKMPokemon) -> Void = { _ in }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        Group{
            switch layout {
            case .twoColumns:
                LazyVGrid(columns: columns) {
                    pokemonsListView
                }
            case .singleColumn:
                LazyVStack(alignment: .leading, spacing: 8) {
                    pokemonsListView
                }
            }
        }
    }
    
    private var pokemonsListView: some View {
        ForEach(Array(pokemons).enumerated(), id: \.offset) { _, pokemon in
            PokemonCardView(
                pokemon: pokemon,
                layout: layout == .twoColumns ? .vertical : .horizontal
            )
            .if(layout == .singleColumn, transform: { view in
                view.frame(height: 90)
            })
            .padding(layout == .twoColumns ? 3 : 0)
            .onAppear { onItemAppear(pokemon) }
            .onTapGesture {
                router.push(.pokemonDetail(name: pokemon.name ?? "Unknown Name"))
            }
        }
    }
}

struct PokemonListPreviewLoader: View {
    @StateObject private var pokemonVM = PokemonHomeViewModel(pokemonService: PokemonService())
    
    var layout: ListLayout
    
    var body: some View {
        ScrollView{
            PokemonListView(pokemons: pokemonVM.pokemons, layout: layout, onItemAppear: { pokemon in
                Task { await pokemonVM.loadNextPageIfNeeded(pokemon: pokemon) }
            })
            .padding(.horizontal)
        }
        .environmentObject(NavigationRouter())
        .task {
            if pokemonVM.pokemons.isEmpty {
                await pokemonVM.loadInitialPage()
            }
        }
    }
}

#Preview("Two Columns") {
    PokemonListPreviewLoader(layout: .twoColumns)
}

#Preview("One Column") {
    PokemonListPreviewLoader(layout: .singleColumn)
}
