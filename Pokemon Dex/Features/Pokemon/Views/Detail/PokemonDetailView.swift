//
//  PokemonDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonDetailView: View {
    
    @StateObject private var pokemonVM = PokemonDetailViewModel(pokemonService: DataProvider.shared.pokemonService)
    
    let pokemonName: String
    
    private var pokemonColor: Color {
        pokemonVM.currentPokemon?.details.types?.first?.color ?? .gray
    }
    
    var body: some View {
        ViewStateHandler(viewModel: pokemonVM) {
            VStack {
                if case .notFound = pokemonVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like we couldn't find this Pokémon!")
                } else if let pokemon = pokemonVM.currentPokemon {
                    ScrollView {
                        PokemonHeader(color: pokemonColor, imageURL: pokemon.details.sprites?.other?.officialArtwork?.frontDefault)
                            .padding(.bottom, 87)
                        
                        VStack(spacing: 25) {
                            
                            PokemonBasicInfoSection(
                                order: pokemon.details.order ?? 0,
                                name: pokemon.details.name ?? "Unknown",
                                types: pokemon.details.types,
                                description: pokemon.species.flavorTextEntries?.englishFlavorText() ?? "No description available."
                            )
                            PokemonStatsSection(stats: pokemon.details.stats ?? [], color: pokemonColor)
                            
                            PokemonAbilitiesSection(abilities: pokemon.details.abilities ?? [], color: pokemonColor)
                            
                            PokemonEvolutionSection(evolution: pokemon.evolution, color: pokemonColor)
                            
                            PokemonFormsSection(for: pokemon.details.name ?? "Unknown", forms: pokemon.forms, color: pokemonColor)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .task {
            await pokemonVM.loadPokemon(name: pokemonName)
        }
    }
}

#Preview {
    PokemonDetailView(pokemonName: "mimikyu-disguised")
        .environmentObject(NavigationRouter())
        .preferredColorScheme(.light)
}
