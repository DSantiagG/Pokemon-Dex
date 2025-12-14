//
//  AbilityPokemonSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 4/12/25.
//
import SwiftUI
import PokemonAPI

struct AbilityPokemonSection: View {
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPokemon: String?
    @State private var pokemonKind: PokemonKind = .normal
    
    var normalPokemon: [PKMPokemon]
    var hiddenPokemon: [PKMPokemon]
    var color: Color
    
    let context: NavigationContext
    
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
