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
    
    @EnvironmentObject private var router: NavigationRouter
    
    let pokemonName: String
    
    private var pokemonColor: Color {
        pokemonVM.currentPokemon?.details.types?.first?.color ?? .gray
    }
    
    var body: some View {
        ViewStateView(viewModel: pokemonVM) {
            VStack {
                if case .notFound = pokemonVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like this Pokémon ran away before we could catch it!")
                } else if let pokemon = pokemonVM.currentPokemon {
                    ScrollView {
                        PokemonHeaderView(color: pokemonColor, imageURL: pokemon.details.sprites?.other?.officialArtwork?.frontDefault)
                            .padding(.bottom, 87)
                        
                        VStack(spacing: 25) {
                            
                            PokemonBasicInfoSection(
                                order: pokemon.details.order ?? 0,
                                name: pokemon.details.name ?? "Unknown",
                                types: pokemon.details.types,
                                flavorText: pokemon.species.englishFlavorText() ?? "No description available."
                            )
                            
                            StatsSection(stats: pokemon.details.stats ?? [], color: pokemonColor)
                            
                            AbilitiesSection(abilities: pokemon.details.abilities ?? [], color: pokemonColor)
                            
                            EvolutionChainSection(evolution: pokemon.evolution, color: pokemonColor)
                                .environmentObject(router)
                                .padding(.bottom, 60)
                        }
                        .padding(.horizontal)
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
    PokemonDetailView(pokemonName: "pikachu-hoenn-cap")
        .environmentObject(NavigationRouter())
        .preferredColorScheme(.light)
}
