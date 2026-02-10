//
//  AbilityDetailViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import SwiftUI
import Combine

import PokemonAPI

/// View model for the ability detail screen.
///
/// Loads an ability and its related Pokémon lists (normal and hidden). The
/// view model exposes `currentAbility` and `state` for the UI to observe.
final class AbilityDetailViewModel: ObservableObject, ErrorHandleable {
    
    // MARK: - Published
    /// The currently loaded ability and related Pokémon.
    @Published var currentAbility: CurrentAbility?
    /// The current view state (idle/loading/loaded/notFound/error).
    @Published var state: ViewState = .idle
    
    // MARK: - Services
    /// Service used to fetch ability resources. (``AbilityService``)
    private let abilityService: AbilityService
    /// Service used to fetch Pokémon resources. (``PokemonService``)
    private let pokemonService: PokemonService
    
    // MARK: - Init

    init(abilityService: AbilityService, pokemonService: PokemonService) {
        self.abilityService = abilityService
        self.pokemonService = pokemonService
    }
    
    // MARK: - Public
    /// Load an ability by its name and update published state.
    ///
    /// - Parameter name: The ability name to load. If `nil` or empty, `state` is set to `.notFound` and the method returns immediately.
    func loadAbility(name: String?) async {
        
        currentAbility = nil
        
        guard let name, !name.isEmpty else {
            state = .notFound
            return
        }
        
        state = .loading
        
        do{
            currentAbility = try await fetchAllAbilityData(name: name)
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading ability with name : \(name) failed", userMessage: "Something went wrong while loading this ability. Tap retry to check again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadAbility(name: name)
                }
            }
            currentAbility = nil
        }
    }
    
    // MARK: - Private
    /// Fetch ability details and related Pokémon lists.
    ///
    /// This helper coordinates fetching the `PKMAbility` followed by resolving
    /// the associated Pokémon into two lists: normal and hidden. If either list
    /// cannot be produced the method returns `nil` to indicate incomplete data.
    ///
    /// - Parameter name: Ability slug to fetch.
    /// - Returns: A populated `CurrentAbility` or `nil` if any required data is missing.
    /// - Throws: Rethrows errors from `fetchAbility(name:)` or `fetchPokemons(for:)`.
    private func fetchAllAbilityData(name: String) async throws -> CurrentAbility? {
        
        let ability = try await fetchAbility(name: name)

        let (normal, hidden) = try await fetchPokemons(for: ability)
        
        guard let normal else { return nil }
        guard let hidden else { return nil }

        return CurrentAbility(
            details: ability,
            normalPokemons: normal,
            hiddenPokemons: hidden
        )
    }
    
    /// Fetch a single ability model by name.
    ///
    /// - Parameter name: Ability slug to fetch.
    /// - Returns: A decoded `PKMAbility` instance.
    /// - Throws: Errors propagated from the underlying ``AbilityService``.
    private func fetchAbility(name: String) async throws -> PKMAbility {
        try await abilityService.fetch(byName: name)
    }
    
    /// Fetch Pokémon associated with the ability, split into normal and hidden lists.
    ///
    /// The method uses a concurrent task group to fetch Pokémon in parallel for
    /// each `ability.pokemon` entry. Results are aggregated into two arrays.
    ///
    /// - Parameter ability: The `PKMAbility` whose `pokemon` resource entries will be resolved.
    /// - Returns: A tuple `(normal: [PKMPokemon]?, hidden: [PKMPokemon]?)`. Arrays may be empty; `nil` indicates the absence of the `pokemon` list on the ability.
    /// - Throws: Errors thrown by the underlying ``PokemonService`` while fetching individual Pokémon.
    private func fetchPokemons(for ability: PKMAbility) async throws -> (normal: [PKMPokemon]?, hidden: [PKMPokemon]?) {

        guard let abilityPokemons = ability.pokemon else { return (nil, nil) }

        var normalPokemons: [PKMPokemon] = []
        var hiddenPokemons: [PKMPokemon] = []

        try await withThrowingTaskGroup(of: (isHidden: Bool, pokemon: PKMPokemon)?.self) { group in
            for abilityPokemon in abilityPokemons {
                group.addTask { [pokemonService] in
                    guard let resource = abilityPokemon.pokemon else { return nil }
                    let pokemon = try await pokemonService.fetch(resource: resource)
                    return (abilityPokemon.isHidden ?? false, pokemon)
                }
            }
            for try await result in group {
                guard let result else { continue }

                if result.isHidden {
                    hiddenPokemons.append(result.pokemon)
                } else {
                    normalPokemons.append(result.pokemon)
                }
            }
        }
        return (normalPokemons, hiddenPokemons)
    }
}

// MARK: - Presentation
extension AbilityDetailViewModel {
    
    /// Display name for the ability.
    ///
    /// - Returns: A formatted name or "Unknown Name" when unavailable.
    var displayName: String {
        currentAbility?.details.name?.formattedName() ?? "Unknown Name"
    }
    
    /// Primary display color derived from the first Pokémon type.
    ///
    /// - Returns: A `Color` derived from the first normal Pokémon's first type; falls back to `.gray`.
    var displayColor: Color {
        currentAbility?.normalPokemons.first?.types?.first?.color ?? .gray
    }
    
    /// The generation string for the ability.
    ///
    /// - Returns: A user-facing generation string (e.g. "Generation III") or a fallback.
    var displayGeneration: String {
        currentAbility?.details.generation?.name?.formattedGeneration() ?? "Unknown Generation"
    }
    
    /// Short description (flavor text) for the ability.
    ///
    /// - Returns: Cleaned English flavor text or a placeholder when missing.
    var displayDescription: String{
        currentAbility?.details.flavorTextEntries?.englishFlavorText() ?? "No description available."
    }
    
    /// Short effect text for the ability.
    ///
    /// - Returns: Cleaned English effect text or a placeholder when missing.
    var displayEffect: String {
        currentAbility?.details.effectEntries?.first(where: { $0.language?.name == "en" })?.effect?.cleanFlavorText() ?? "No effect available."
    }
}
