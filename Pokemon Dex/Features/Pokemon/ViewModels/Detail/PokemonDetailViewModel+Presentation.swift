//
//  PokemonDetailViewModel+Presentation.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//

import Foundation
import SwiftUI

import PokemonAPI

extension PokemonDetailViewModel {
    
    var displayColor: Color {
        currentPokemon?.details.types?.first?.color ?? .gray
    }
    
    var displayName: String {
        currentPokemon?.details.name?.formattedName() ?? "Unknown Name"
    }
    
    var displayOrder: Int {
        currentPokemon?.details.order ?? 0
    }
    
    var displayTypes: [String] {
        currentPokemon?.types.map { $0.name?.formattedName() ?? "Unknown Type" } ?? []
    }
    
    var displayDescription: String {
        currentPokemon?.species.flavorTextEntries?.englishFlavorText() ?? "No description available."
    }
    
    var displayGeneration: String {
        currentPokemon?.species.generation?.name?.formattedGeneration() ?? "Unknown Generation"
    }
    
    var displayWeight: Double {
        (currentPokemon?.details.weight.map(Double.init)).map { $0 / 10.0 } ?? 0.0
    }
    
    var displayHeight: Double{
        (currentPokemon?.details.height.map(Double.init)).map { $0 / 10.0 } ?? 0.0
    }
    
    var displayStats: [(name: String, value: Int)] {
        guard let stats = currentPokemon?.details.stats else { return [] }

        return stats.map { s in
            let name = (s.stat?.name ?? "stat")
                .replacingOccurrences(of: "special-attack", with: "Sp. Attack")
                .replacingOccurrences(of: "special-defense", with: "Sp. Defense")
                .formattedName()

            return (name: name, value: s.baseStat ?? 0)
        }
    }
    
    var displayHabit: String {
        currentPokemon?.species.habitat?.name?.formattedName() ?? "Unknown Habit"
    }
    
    var displayCaptureRate: Int {
        currentPokemon?.species.captureRate ?? 0
    }
    
    var displayBaseExperience: Int {
        currentPokemon?.details.baseExperience ?? 0
    }
    
    var displayGrowthRate: String {
        currentPokemon?.species.growthRate?.name?.formattedName() ?? "Unknown"
    }
    
    var displayFemaleRatioPercent: Double? {
        guard let rate = currentPokemon?.species.genderRate, rate != -1 else { return nil }
        return (Double(rate) / 8.0) * 100.0
    }

    var displayMaleRatioPercent: Double? {
        guard let female = displayFemaleRatioPercent else { return nil }
        return 100.0 - female
    }
    
    var displayEggCycles: Int {
        currentPokemon?.species.hatchCounter ?? 0
    }
    
    var displayEggGroups: [String] {
        currentPokemon?.species.eggGroups?.compactMap { $0.name?.formattedName() } ?? []
    }
    
    var displayEvolutionStages: [EvolutionStageViewModel] {
        currentPokemon?.evolution.map { EvolutionStageViewModel(stage: $0) } ?? []
    }
    
    var displayPokemonForms: [PokemonFormViewModel] {
        currentPokemon?.forms.map { PokemonFormViewModel(form: $0) } ?? []
    }
}
