//
//  PokemonDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/11/25.
//

import SwiftUI
import PokemonAPI

/// Detailed view that presents a Pokémon's full information using a composed set of detail sections.
///
/// - Parameters:
///   - pokemonName: Optional slug/name of the Pokémon to load (for example, "bulbasaur"). If `nil` nothing will be loaded.
///   - context: The navigation presentation context that influences how child views should navigate or present sheets. See ``NavigationContext``.
///
/// - Note: The view delegates loading/error handling to ``ViewStateHandler`` and performs the initial load in a `.task` by calling
///   ``PokemonDetailViewModel/loadPokemon(name:)``.
struct PokemonDetailView: View {
    
    // MARK: - ViewModel
    
    /// Owns loading, state, and data used by the view.
    @StateObject private var pokemonVM = PokemonDetailViewModel(pokemonService: DataProvider.shared.pokemonService, abilityService: DataProvider.shared.abilityService, itemService: DataProvider.shared.itemService)
    
    // MARK: - Parameters
    
    let pokemonName: String?
    var context: NavigationContext = .main
    
    //MARK: - Body
    
    var body: some View {
        ViewStateHandler(viewModel: pokemonVM) {
            VStack {
                if case .notFound = pokemonVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like we couldn't find this Pokémon!")
                } else if let pokemon = pokemonVM.currentPokemon {
                    ScrollView {
                        CustomHeader(
                            color: pokemonVM.displayColor,
                            imageURL: pokemon.details.sprites?.other?.officialArtwork?.frontDefault,
                            soundURL: pokemon.details.cries?.latest
                        )
                        .padding(.bottom, 87)
                        
                        VStack(spacing: 25) {
                            
                            PokemonBasicInfoSection(
                                order: pokemonVM.displayOrder,
                                name: pokemonVM.displayName,
                                types: pokemonVM.displayTypes,
                                description: pokemonVM.displayDescription)
                            
                            PokemonCharacteristicsSection(
                                generation: pokemonVM.displayGeneration,
                                weight: pokemonVM.displayWeight,
                                height: pokemonVM.displayHeight,
                                color: pokemonVM.displayColor
                            )
                        
                            PokemonStatsSection(
                                stats: pokemonVM.displayStats,
                                color: pokemonVM.displayColor
                            )
                            
                            PokemonAbilitiesSection(
                                normalAbilities: pokemon.normalAbilities,
                                hiddenAbilities: pokemon.hiddenAbilities,
                                color: pokemonVM.displayColor,
                                context: context
                            )
                            
                            PokemonCaptureSection(
                                habit: pokemonVM.displayHabit,
                                captureRate: pokemonVM.displayCaptureRate,
                                baseExperience: pokemonVM.displayBaseExperience,
                                growthRate: pokemonVM.displayGrowthRate,
                                color: pokemonVM.displayColor
                            )
                            
                            PokemonBreedingSection(
                                genderRatio: .init(
                                    femaleRatio: pokemonVM.displayFemaleRatioPercent,
                                    maleRatio: pokemonVM.displayFemaleRatioPercent
                                ),
                                eggCycles: pokemonVM.displayEggCycles,
                                eggGroups: pokemonVM.displayEggGroups,
                                color: pokemonVM.displayColor
                            )
                            
                            PokemonItemsSection(
                                items: pokemon.items,
                                color: pokemonVM.displayColor,
                                context: context)
                            
                            PokemonEvolutionSection(
                                evolution: pokemonVM.displayEvolutionStages,
                                color: pokemonVM.displayColor,
                                context: context
                            )
                            
                            PokemonFormsSection(
                                for: pokemon.details.name,
                                forms: pokemonVM.displayPokemonForms,
                                color: pokemonVM.displayColor,
                                context: context
                            )
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                    .toolbar {
                        Button {
                            Task{
                                await pokemonVM.toggleFavorite()
                            }
                        } label: {
                            Image(systemName: pokemonVM.isFavorite ? "heart.fill" : "heart")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(pokemonVM.displayColor)
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
        PokemonDetailView(pokemonName: "meowth")
            .environmentObject(NavigationRouter())
    }
}
