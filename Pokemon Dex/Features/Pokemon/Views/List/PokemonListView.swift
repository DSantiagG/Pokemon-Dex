//
//  PokemonListView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonListView: View {
    
    enum ListLayout {
        case twoColumns
        case singleColumn
    }
    
    @EnvironmentObject private var router: NavigationRouter
    
    let pokemons: [PKMPokemon]
    var layout: ListLayout = .twoColumns
    
    var onItemAppear: (PKMPokemon) -> Void = { _ in }
    var onItemSelected: () -> Void = { }
    
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
            PokemonCard(
                pokemon: pokemon,
                layout: layout == .twoColumns ? .vertical : .horizontal
            )
            .if(layout == .singleColumn, transform: { view in
                view.frame(height: 90)
            })
            .padding(layout == .twoColumns ? 3 : 0)
            .onAppear { onItemAppear(pokemon) }
            .onTapGesture {
                onItemSelected()
                router.push(.pokemonDetail(name: pokemon.name ?? "Unknown Name"))
            }
        }
    }
}

#Preview("Two Columns") {
    let pokemon = PokemonMockFactory.mockBulbasaur()
    let list = Array(repeating: pokemon, count: 30)
    ScrollView{
        PokemonListView(pokemons: list,layout: .twoColumns)
            .padding(.horizontal)
    }
}

#Preview("One Column") {
    let pokemon = PokemonMockFactory.mockBulbasaur()
    let list = Array(repeating: pokemon, count: 30)
    ScrollView{
        PokemonListView(pokemons: list,layout: .singleColumn)
            .padding(.horizontal)
    }
}
