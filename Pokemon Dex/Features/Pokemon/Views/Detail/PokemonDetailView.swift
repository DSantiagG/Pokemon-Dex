//
//  PokemonDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonDetailView: View {
    
    @StateObject private var pokemonVM = PokemonDetailViewModel(pokemonService: DataProvider.shared.pokemonService, abilityService: DataProvider.shared.abilityService)
    
    let pokemonName: String
    
    private var pokemonColor: Color {
        pokemonVM.currentPokemon?.details.types?.first?.color ?? .gray
    }
    
    private var femaleRatioPercent: Double? {
        guard let rate = pokemonVM.currentPokemon?.species.genderRate,
              rate != -1 else { return nil }
        return (Double(rate) / 8.0) * 100.0
    }

    private var maleRatioPercent: Double? {
        guard let female = femaleRatioPercent else { return nil }
        return 100.0 - female
    }
    
    var body: some View {
        ViewStateHandler(viewModel: pokemonVM) {
            VStack {
                if case .notFound = pokemonVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like we couldn't find this Pokémon!")
                } else if let pokemon = pokemonVM.currentPokemon {
                    ScrollView {
                        PokemonHeader(
                            color: pokemonColor,
                            imageURL: pokemon.details.sprites?.other?.officialArtwork?.frontDefault,
                            cryURL: pokemon.details.cries?.latest
                        )
                        .padding(.bottom, 87)
                        
                        VStack(spacing: 25) {
                            
                            PokemonBasicInfoSection(
                                order: pokemon.details.order ?? 0,
                                name: pokemon.details.name ?? "Unknown",
                                types: pokemon.details.types,
                                description: pokemon.species.flavorTextEntries?.englishFlavorText() ?? "No description available."
                            )
                            
                            PokemonCharacteristicsSection(
                                generation: pokemon.species.generation?.name?.formattedGeneration() ?? "Unknown",
                                weight: (pokemon.details.weight.map(Double.init)).map { $0 / 10.0 } ?? 0.0,
                                height: (pokemon.details.height.map(Double.init)).map { $0 / 10.0 } ?? 0.0,
                                color: pokemonColor
                            )
                        
                            PokemonStatsSection(
                                stats: pokemon.details.stats ?? [],
                                color: pokemonColor
                            )
                            
                            PokemonAbilitiesSection(
                                normalAbilities: pokemon.normalAbilities,
                                hiddenAbilities: pokemon.hiddenAbilities,
                                color: pokemonColor
                            ) {}
                            
                            PokemonCaptureSection(
                                habit: pokemon.species.habitat?.name?.formattedName() ?? "Unknown",
                                captureRate: pokemon.species.captureRate ?? 0,
                                baseExperience: pokemon.details.baseExperience ?? 0,
                                growthRate: pokemon.species.growthRate?.name?.formattedName() ?? "Unknown",
                                color: pokemonColor
                            )
                            
                            PokemonBreedingSection(
                                genderRatio: .init(
                                    femaleRatio: femaleRatioPercent,
                                    maleRatio: maleRatioPercent
                                ),
                                eggCycles: pokemon.species.hatchCounter ?? 0,
                                eggGroups: pokemon.species.eggGroups?.compactMap { $0.name?.formattedName() } ?? [],
                                color: pokemonColor
                            )
                            
                            PokemonEvolutionSection(
                                evolution: pokemon.evolution,
                                color: pokemonColor
                            )
                            
                            PokemonFormsSection(
                                for: pokemon.details.name ?? "Unknown",
                                forms: pokemon.forms,
                                color: pokemonColor
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    .toolbar {
                        Button {} label: {
                            Image(systemName: "heart")
                        }
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
    NavigationStack{
        PokemonDetailView(pokemonName: "bulbasaur")
            .environmentObject(NavigationRouter())
            .preferredColorScheme(.light)
    }
}
