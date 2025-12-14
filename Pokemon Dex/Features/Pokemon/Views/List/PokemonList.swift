//
//  PokemonListView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonList: View {
    
    let pokemons: [PKMPokemon]
    var layout: ListLayout = .twoColumns
    
    var onItemAppear: (PKMPokemon) -> Void = { _ in }
    var onItemSelected: (String?) -> Void = { _ in }
    
    var body: some View {
        CardList(
            items: pokemons,
            layout: layout,
            onItemAppear: onItemAppear,
            onItemSelected: { p in onItemSelected(p.name)},
            content: { pokemon, layout in
                PokemonCard(
                    pokemon: pokemon,
                    layout: layout == .twoColumns ? .vertical : .horizontal
                )
                .frame(height: layout == .singleColumn ? 90 : 220)
            })
    }
}

#Preview("Two Columns") {
    let list = Array(repeating: PokemonMockFactory.mockBulbasaur(), count: 30)
    ScrollView{
        PokemonList(pokemons: list,layout: .twoColumns)
            .padding(.horizontal)
    }
}

#Preview("One Column") {
    let list = Array(repeating: PokemonMockFactory.mockBulbasaur(), count: 30)
    ScrollView{
        PokemonList(pokemons: list,layout: .singleColumn)
            .padding(.horizontal)
    }
}
