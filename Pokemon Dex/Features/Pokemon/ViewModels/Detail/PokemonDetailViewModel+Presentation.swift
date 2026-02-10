//
//  PokemonDetailViewModel+Presentation.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//

import Foundation
import SwiftUI

import PokemonAPI

/// Presentation helpers for `PokemonDetailViewModel`.
///
/// This extension exposes computed properties used by views to display
/// user-friendly values (formatted names, derived color, stats, and lists of
/// presentation view models). Keep these inexpensive and free of side-effects.
extension PokemonDetailViewModel {
    
    /// Accent color derived from the Pokémon's first type.
    ///
    /// - Returns: A `Color` suitable for UI accents; falls back to `.gray` when unavailable.
    var displayColor: Color {
        currentPokemon?.details.types?.first?.color ?? .gray
    }
    
    /// Human-friendly Pokémon name for display.
    ///
    /// - Returns: A formatted name (capitalized, hyphens → spaces) or "Unknown Name" when missing.
    var displayName: String {
        currentPokemon?.details.name?.formattedName() ?? "Unknown Name"
    }
    
    /// Numeric order/index used for display or sorting.
    ///
    /// - Returns: The Pokémon `order` value or `0` when unknown.
    var displayOrder: Int {
        currentPokemon?.details.order ?? 0
    }
    
    /// Displayable type names.
    ///
    /// - Returns: An array of formatted type names (e.g. ["Grass", "Poison"]) or `[]` when unavailable.
    var displayTypes: [String] {
        return currentPokemon?.details.types?.map { $0.type?.name?.formattedName() ?? "Unknown Type"} ?? []
    }
    
    /// English flavor text / description suitable for a header or summary.
    ///
    /// - Returns: Cleaned English flavor text or a placeholder when missing.
    var displayDescription: String {
        currentPokemon?.species.flavorTextEntries?.englishFlavorText() ?? "No description available."
    }
    
    /// User-facing generation string (e.g. "Generation III").
    ///
    /// - Returns: A formatted generation string or "Unknown Generation" when missing.
    var displayGeneration: String {
        currentPokemon?.species.generation?.name?.formattedGeneration() ?? "Unknown Generation"
    }
    
    /// Display weight in kilograms.
    ///
    /// - Returns: Weight converted from hectograms to kilograms (value / 10) or `0.0` when unknown.
    var displayWeight: Double {
        (currentPokemon?.details.weight.map(Double.init)).map { $0 / 10.0 } ?? 0.0
    }
    
    /// Display height in meters.
    ///
    /// - Returns: Height converted from decimeters to meters (value / 10) or `0.0` when unknown.
    var displayHeight: Double{
        (currentPokemon?.details.height.map(Double.init)).map { $0 / 10.0 } ?? 0.0
    }
    
    /// Stat name/value pairs prepared for presentation.
    ///
    /// - Returns: An array of tuples `(name: String, value: Int)` where `name` is a human-friendly stat label and `value` is the base stat.
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
    
    /// Habitat display name.
    ///
    /// - Returns: Formatted habitat name or "Unknown Habit" when missing.
    var displayHabit: String {
        currentPokemon?.species.habitat?.name?.formattedName() ?? "Unknown Habit"
    }
    
    /// Capture rate used for display.
    ///
    /// - Returns: Integer capture rate or `0` when unavailable.
    var displayCaptureRate: Int {
        currentPokemon?.species.captureRate ?? 0
    }
    
    /// Base experience value for display.
    ///
    /// - Returns: The Pokémon's `baseExperience` or `0` when unknown.
    var displayBaseExperience: Int {
        currentPokemon?.details.baseExperience ?? 0
    }
    
    /// Growth rate label.
    ///
    /// - Returns: Formatted growth rate name or "Unknown" when missing.
    var displayGrowthRate: String {
        currentPokemon?.species.growthRate?.name?.formattedName() ?? "Unknown"
    }
    
    /// Female ratio percentage for the species, or `nil` if genderless.
    ///
    /// - Returns: Percentage (0..100) of females or `nil` when the species is genderless.
    var displayFemaleRatioPercent: Double? {
        guard let rate = currentPokemon?.species.genderRate, rate != -1 else { return nil }
        return (Double(rate) / 8.0) * 100.0
    }

    /// Male ratio percentage derived from the female percentage.
    ///
    /// - Returns: Male percentage (0..100) or `nil` when female ratio is `nil`.
    var displayMaleRatioPercent: Double? {
        guard let female = displayFemaleRatioPercent else { return nil }
        return 100.0 - female
    }
    
    /// Number of egg cycles / hatch counter.
    ///
    /// - Returns: Hatch counter integer or `0` when unknown.
    var displayEggCycles: Int {
        currentPokemon?.species.hatchCounter ?? 0
    }
    
    /// Egg group display names.
    ///
    /// - Returns: Array of formatted egg group names or an empty array when unavailable.
    var displayEggGroups: [String] {
        currentPokemon?.species.eggGroups?.compactMap { $0.name?.formattedName() } ?? []
    }
    
    /// Evolution stages converted to presentation view models.
    ///
    /// - Returns: An array of `EvolutionStageViewModel` representing the evolution chain.
    var displayEvolutionStages: [EvolutionStageViewModel] {
        currentPokemon?.evolution.map { EvolutionStageViewModel(stage: $0) } ?? []
    }
    
    /// Pokémon forms converted to presentation view models.
    ///
    /// - Returns: An array of `PokemonFormViewModel` representing available forms.
    var displayPokemonForms: [PokemonFormViewModel] {
        currentPokemon?.forms.map { PokemonFormViewModel(form: $0) } ?? []
    }
}
