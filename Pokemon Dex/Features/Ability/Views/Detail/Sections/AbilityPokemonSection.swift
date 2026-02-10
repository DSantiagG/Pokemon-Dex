//
//  AbilityPokemonSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 4/12/25.
//
import SwiftUI
import PokemonAPI

/// Section that lists Pokémon affected by an ability.
///
/// - Parameters:
///   - normalPokemon: Pokémon shown when `pokemonKind == .normal`.
///   - hiddenPokemon: Pokémon shown when `pokemonKind == .hidden`.
///   - color: Accent color for the section.
///   - context: Navigation context controlling push vs sheet behavior.
///
/// - Behavior:
///   - Uses `CustomSegmentedControl` to switch between normal and hidden lists.
///   - Selecting a Pokémon either pushes or presents a sheet depending on `context`.
struct AbilityPokemonSection: View {
    
    // MARK: - Environment
    /// Router used for navigation actions.
    @EnvironmentObject private var router: NavigationRouter
    /// Dismiss action for sheet contexts.
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    /// Currently selected Pokémon name for sheet presentation.
    @State private var selectedPokemon: String?
    /// Selected kind (normal/hidden) for the segmented control.
    @State private var pokemonKind: PokemonKind = .normal
    
    // MARK: - Properties
    var normalPokemon: [PKMPokemon]
    var hiddenPokemon: [PKMPokemon]
    var color: Color
    let context: NavigationContext
    
    // MARK: - View
    
    var body: some View {
        SectionCard(text: "Potential Pokémon", color: color) {
            CustomSegmentedControl(selection: $pokemonKind, color: color, items: [
                .init("Normal", tag: .normal),
                .init("Hidden", tag: .hidden)
            ])
            
            PokemonList(pokemons: (pokemonKind == .normal) ? normalPokemon : hiddenPokemon, layout: .singleColumn, onItemSelected: { pokemonName in
                switch context {
                case .sheet(.pokemon):
                    dismiss()
                    router.push(.pokemonDetail(name: pokemonName))
                case .main, .sheet(.ability):
                    selectedPokemon = pokemonName
                case .sheet(.item):
                    break
                }
            })
        }
        .sheet(item: $selectedPokemon) { pokemonName in
            PokemonDetailView(pokemonName: pokemonName, context: .sheet(.ability))
                .presentationDetents([.medium, .large])
                .presentationBackground(Color(.systemBackground))
        }
    }
}

#Preview {
    let pokemon = PokemonMockFactory.mockBulbasaur()
    
    ScrollView{
        AbilityPokemonSection(normalPokemon: [pokemon], hiddenPokemon: [pokemon], color: .green, context: .main)
            .environmentObject(NavigationRouter())
            .padding(.horizontal)
    }
}
