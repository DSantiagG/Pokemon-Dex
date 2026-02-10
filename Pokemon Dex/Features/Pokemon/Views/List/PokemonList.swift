//
//  PokemonListView.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

/// A list container that renders an array of Pokémons using the chosen layout.
///
/// - Parameters:
///   - pokemons: An array of ``PKMPokemon`` to display.
///   - layout: The ``ListLayout`` to render (single column or two columns).
///   - onItemAppear: Closure invoked when a cell becomes visible (used for pagination triggers).
///   - onItemSelected: Callback invoked with the selected Pokémon name when a card is tapped.
///
/// - Example:
/// ```swift
/// PokemonList(pokemons: myPokemons, layout: .twoColumns) { name in
///     print("Selected: \(name)")
/// }
/// ```
struct PokemonList: View {

    // MARK: - Properties
    let pokemons: [PKMPokemon]
    var layout: ListLayout = .twoColumns

    var onItemAppear: (PKMPokemon) -> Void = { _ in }
    var onItemSelected: (String?) -> Void = { _ in }

    // MARK: - Body
    var body: some View {
        CardList(
            items: pokemons,
            layout: layout,
            onItemAppear: onItemAppear,
            onItemSelected: { p in onItemSelected(p.name) },
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
