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
class PokemonDetailViewModel: ObservableObject, ErrorHandleable {
    
    @Published var currentPokemon: CurrentPokemon?
    @Published var state: ViewState = .idle
    
    private let pokemonService: PokemonService
    private let abilityService: AbilityService
    private let itemService: ItemService
    
    init(pokemonService: PokemonService, abilityService: AbilityService, itemService: ItemService) {
        self.pokemonService = pokemonService
        self.abilityService = abilityService
        self.itemService = itemService
    }
    
    func loadPokemon(name: String) async {
        
        state = .loading
        currentPokemon = nil
        
        do{
            currentPokemon = try await fetchAllPokemonData(name: name)
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
    
    private func fetchAllPokemonData(name: String) async throws -> CurrentPokemon? {
        
        guard let pokemon = try await fetchPokemon(name: name) else { return nil }
        
        guard let types = try await fetchTypes(for: pokemon) else { return nil }
        
        let (normalAbilities, hiddenAbilities) = try await fetchAbilities(for: pokemon)
        
        guard let normalAbilities else { return nil }
        guard let hiddenAbilities else { return nil }
        
        guard let species = try await fetchSpecies(for: pokemon) else { return nil }
        
        guard let evolution = try await fetchEvolution(for: species) else { return nil }
        
        guard let forms = try await fetchForms(for: species) else { return nil }
        
        guard let items = try await fetchHeldItems(for: pokemon) else { return nil }
        
        return CurrentPokemon(
            details: pokemon,
            types: types,
            normalAbilities: normalAbilities,
            hiddenAbilities: hiddenAbilities,
            species: species,
            evolution: evolution,
            forms: forms,
            items: items
        )
    }
    
    private func fetchPokemon(name: String?) async throws -> PKMPokemon? {
        guard let name else { return nil }
        return try await pokemonService.fetch(name: name)
    }
    
    private func fetchTypes(for pokemon: PKMPokemon) async throws -> [PKMType]? {
        guard let pokemonTypes = pokemon.types else { return nil }

        var types: [PKMType] = []

        for t in pokemonTypes {
            guard let typeResource = t.type else { continue }
            let typeDetails = try await pokemonService.fetchType(resource: typeResource)
            types.append(typeDetails)
        }
        return types
    }
    
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
    
    private func fetchSpecies(for pokemon: PKMPokemon) async throws -> PKMPokemonSpecies? {
        guard let resource = pokemon.species else { return nil }
        return try await pokemonService.fetchSpecies(resource: resource)
    }
    
    private func fetchEvolution(for species: PKMPokemonSpecies) async throws -> [EvolutionStage]? {
        guard let resource = species.evolutionChain else { return nil }
        return try await pokemonService.fetchEvolutionChain(resource: resource)
    }
    
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
    
    private func fetchHeldItems(for pokemon: PKMPokemon) async throws -> [PKMItem]? {
        guard let heldItems = pokemon.heldItems else { return nil }
        
        let heldItemsResources = heldItems.compactMap { $0.item }
        return try await itemService.fetch(from: heldItemsResources)
    }
}
