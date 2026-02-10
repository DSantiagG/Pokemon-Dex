//
//  ItemPokemonSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import SwiftUI
import PokemonAPI

/// Section that displays the list of Pokémon that hold the current item.
///
/// - Parameters:
///   - pokemons: Array of `PKMPokemon` who can hold the item.
///   - color: Accent color used for the section styling.
///   - context: NavigationContext describing how navigation should be handled when selecting a Pokémon.
///
/// Behavior:
/// - If `context` indicates the parent is a sheet for Pokémon, the section will dismiss and push the detail route.
/// - Otherwise, it presents a sheet with the selected Pokémon detail when tapped.
struct ItemPokemonSection: View {
    
    // MARK: - Environment
    /// Router used for navigation actions, injected from parent views.
    @EnvironmentObject private var router: NavigationRouter
    /// Dismiss action for closing sheets, used when context indicates we're in a Pokémon sheet.
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var selectedPokemon: String?
    
    // MARK: - Parameters
    
    let pokemons: [PKMPokemon]
    var color: Color
    
    let context: NavigationContext
    
    // MARK: - Body
    
    var body: some View {
        if !pokemons.isEmpty{
            SectionCard(text: "Held By", color: color) {
                PokemonList(pokemons: pokemons, layout: .singleColumn, onItemSelected: { pokemonName in
                    switch context {
                    case .sheet(.pokemon):
                        dismiss()
                        router.push(.pokemonDetail(name: pokemonName))
                    case .main, .sheet(.item):
                        selectedPokemon = pokemonName
                    case .sheet(.ability):
                        break
                    }
                })
            }
            .sheet(item: $selectedPokemon) { pokemonName in
                    PokemonDetailView(pokemonName: pokemonName, context: .sheet(.item))
                            .presentationDetents([.medium, .large])
                            .presentationBackground(Color(.systemBackground))
            }
        }
    }
}

#Preview {
    let pokemon = PokemonMockFactory.mockBulbasaur()
    
    ScrollView{
        ItemPokemonSection(pokemons: [pokemon], color: .green, context: .main)
            .environmentObject(NavigationRouter())
            .padding(.horizontal)
    }
}
