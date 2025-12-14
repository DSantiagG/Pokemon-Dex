//
//  ItemPokemonSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import SwiftUI
import PokemonAPI

struct ItemPokemonSection: View {
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedPokemon: String?
    
    let pokemons: [PKMPokemon]
    var color: Color
    
    let context: NavigationContext
    
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
