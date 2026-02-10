//
//  PokemonDetailViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 22/11/25.
//

import Foundation
import Combine

import PokemonAPI

@MainActor
/// View model responsible for loading a Pokémon's full detail and related entities.
///
/// `PokemonDetailViewModel` orchestrates fetching the `PKMPokemon` model and
/// resolving related resources (abilities, species, evolution stages, forms and held items).
/// It exposes presentation-ready state via published properties.
class PokemonDetailViewModel: ObservableObject, ErrorHandleable {
    
    // MARK: - Published state
    /// Presentation container with resolved details, abilities, species, evolution, forms and items.
    @Published var currentPokemon: CurrentPokemon?
    /// Loading/error/idle view state used by the UI.
    @Published var state: ViewState = .idle
    /// Whether the currently shown Pokémon is marked as favorite by the user.
    @Published var isFavorite: Bool = false
    
    // MARK: - Services
    /// Service used to fetch Pokémon and related data (``PokemonService``).
    private let pokemonService: PokemonService
    /// Service used to fetch ability details (``AbilityService``).
    private let abilityService: AbilityService
    /// Service used to fetch item details (``ItemService``).
    private let itemService: ItemService
    
    // MARK: - Initialization

    init(pokemonService: PokemonService, abilityService: AbilityService, itemService: ItemService) {
        self.pokemonService = pokemonService
        self.abilityService = abilityService
        self.itemService = itemService
    }
    
    // MARK: - Actions
    /// Toggle the favorite state for the currently loaded Pokémon.
    ///
    /// - Important: This method is noop when `currentPokemon` is `nil`.
    func toggleFavorite() async {
        guard let pokemon = currentPokemon?.details else { return }
        await pokemonService.toggleFavorite(pokemon: pokemon)
        isFavorite.toggle()
    }
    
    /// Load the Pokémon by name and resolve all related resources.
    ///
    /// - Parameter name: Optional Pokémon slug to load (e.g. "pikachu"). If `nil` or empty the method sets `state = .notFound`.
    func loadPokemon(name: String?) async {
        
        currentPokemon = nil
        
        guard let name, !name.isEmpty else {
            state = .notFound
            return
        }
        
        state = .loading
        
        do{
            currentPokemon = try await fetchAllPokemonData(name: name)
            await loadIsFavorite()
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading pokemon with name : \(name) failed", userMessage: "This Pokémon is hiding. Tap retry to find it!") { [weak self] in
                Task { @MainActor in
                    await self?.loadPokemon(name: name)
                }
            }
            currentPokemon = nil
        }
    }
    
    // MARK: - Internal fetch orchestration
    /// Fetch the main `PKMPokemon` and resolve abilities, species, evolution stages, forms and held items.
    ///
    /// - Parameter name: Pokémon slug to fetch.
    /// - Returns: A fully populated `CurrentPokemon` or `nil` if any required part is missing.
    /// - Throws: Errors originating from network or decoding failures.
    private func fetchAllPokemonData(name: String) async throws -> CurrentPokemon? {
        
        guard let pokemon = try await fetchPokemon(name: name) else { return nil }
        
        let (normalAbilities, hiddenAbilities) = try await fetchAbilities(for: pokemon)
        
        guard let normalAbilities else { return nil }
        guard let hiddenAbilities else { return nil }
        
        guard let species = try await fetchSpecies(for: pokemon) else { return nil }
        
        guard let evolution = try await fetchEvolution(for: species) else { return nil }
        
        guard let forms = try await fetchForms(for: species) else { return nil }
        
        guard let items = try await fetchHeldItems(for: pokemon) else { return nil }
        
        return CurrentPokemon(
            details: pokemon,
            normalAbilities: normalAbilities,
            hiddenAbilities: hiddenAbilities,
            species: species,
            evolution: evolution,
            forms: forms,
            items: items
        )
    }
    
    // MARK: - Small helpers
    /// Fetch the Pokémon model by name if present.
    ///
    /// - Parameter name: Optional Pokémon slug to resolve (e.g. "pikachu").
    /// - Returns: A decoded `PKMPokemon` instance when found, or `nil` when `name` is nil or not resolvable.
    /// - Throws: Errors propagated from `pokemonService.fetch(name:)` (network/decoding).
    private func fetchPokemon(name: String?) async throws -> PKMPokemon? {
        guard let name else { return nil }
        return try await pokemonService.fetch(name: name)
    }
    
    /// Parallel fetch of abilities; returns separate normal and hidden arrays.
    ///
    /// - Parameter pokemon: The `PKMPokemon` whose `abilities` entries will be resolved.
    /// - Returns: A tuple `(normal: [PKMAbility]?, hidden: [PKMAbility]?)` where arrays are present when abilities were successfully fetched, or `nil` when the source data is missing.
    /// - Throws: Any error encountered while fetching individual ability resources via `abilityService`.
    private func fetchAbilities(for pokemon: PKMPokemon) async throws -> (normal: [PKMAbility]?, hidden: [PKMAbility]?) {

        guard let pokemonAbilities = pokemon.abilities else { return (nil, nil) }

        var normalAbilities: [PKMAbility] = []
        var hiddenAbilities: [PKMAbility] = []

        try await withThrowingTaskGroup(of: (isHidden: Bool, ability: PKMAbility)?.self) { group in
            for pokemonAbility in pokemonAbilities {
                group.addTask { [abilityService] in
                    guard let resource = pokemonAbility.ability else { return nil }
                    let ability = try await abilityService.fetch(byResource: resource)
                    return (pokemonAbility.isHidden ?? false, ability)
                }
            }
            for try await result in group {
                guard let result else { continue }

                if result.isHidden {
                    hiddenAbilities.append(result.ability)
                } else {
                    normalAbilities.append(result.ability)
                }
            }
        }
        return (normalAbilities, hiddenAbilities)
    }
    
    /// Fetch species details for the Pokémon.
    ///
    /// - Parameter pokemon: The `PKMPokemon` whose `species` resource will be fetched.
    /// - Returns: A decoded `PKMPokemonSpecies` or `nil` if the `species` resource is missing.
    /// - Throws: Errors from `pokemonService.fetchSpecies(resource:)`.
    private func fetchSpecies(for pokemon: PKMPokemon) async throws -> PKMPokemonSpecies? {
        guard let resource = pokemon.species else { return nil }
        return try await pokemonService.fetchSpecies(resource: resource)
    }
    
    /// Fetch the evolution stages for the Pokémon species using the service helper.
    ///
    /// - Parameter species: The `PKMPokemonSpecies` whose evolution chain resource will be followed.
    /// - Returns: An ordered array of `EvolutionStage` representing the chain, or `nil` when no chain is present.
    /// - Throws: Errors from the API client while fetching the evolution chain or individual Pokémon.
    private func fetchEvolution(for species: PKMPokemonSpecies) async throws -> [EvolutionStage]? {
        guard let resource = species.evolutionChain else { return nil }
        return try await pokemonService.fetchEvolutionChain(resource: resource)
    }

    /// Resolve the available forms for a species by fetching their representative Pokémon models.
    ///
    /// - Parameter species: The species whose `varieties` are used to fetch representative `PKMPokemon` models.
    /// - Returns: An array of `PokemonForm` representing each resolved variety, or `nil` if the species has no varieties.
    /// - Throws: Any error produced while fetching the representative Pokémon models.
    private func fetchForms(for species: PKMPokemonSpecies) async throws -> [PokemonForm]? {
        guard let varietiesResource = species.varieties else { return nil }
        
        var pokemonForms: [PokemonForm] = []
        
        for variety in varietiesResource {
            guard let pokemon = try await fetchPokemon(name: variety.pokemon?.name) else { continue }
            let sprite = pokemon.sprites?.other?.officialArtwork?.frontDefault
            pokemonForms.append(.init(name: pokemon.name, sprite: sprite, isDefault: variety.isDefault ?? false))
        }
        return pokemonForms
    }
    
    /// Fetch items held by the Pokémon.
    ///
    /// - Parameter pokemon: The Pokémon whose held items will be resolved.
    /// - Returns: An array of `PKMItem` for the held items, or `nil` if the Pokémon has no held items.
    /// - Throws: Any error propagated from `itemService.fetch(from:)` while resolving held item resources.
    private func fetchHeldItems(for pokemon: PKMPokemon) async throws -> [PKMItem]? {
        guard let heldItems = pokemon.heldItems else { return nil }
        
        let heldItemsResources = heldItems.compactMap { $0.item }
        return try await itemService.fetch(from: heldItemsResources)
    }
    
    /// Load favorite flag for the currently loaded Pokémon.
    ///
    /// - Note: Safely checks `currentPokemon` and sets `isFavorite` from the service.
    private func loadIsFavorite() async {
        guard let name = currentPokemon?.details.name else { return }
        isFavorite = await pokemonService.isFavorite(name: name)
    }
}
