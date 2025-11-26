//
//  PokemonDetailViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 22/11/25.
//

import Foundation
import PokemonAPI
import Combine

@MainActor
class PokemonDetailViewModel: ObservableObject, ErrorHandleable {
    
    @Published var currentPokemon: CurrentPokemon?
    @Published var state: ViewState = .idle
    
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    func loadPokemon(name: String) async {
        
        state = .loading
        currentPokemon = nil
        
        do{
            currentPokemon = try await fetchAllPokemonData(name: name)
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading pokemon with name : \(name) failed", userMessage: "This Pokémon is hiding… tap retry to find it!") { [weak self] in
                Task { @MainActor in
                    await self?.loadPokemon(name: name)
                }
            }
            currentPokemon = nil
        }
    }
    
    private func fetchAllPokemonData(name: String) async throws -> CurrentPokemon? {
        
        let pokemon = try await fetchPokemon(name: name)
        
        guard let species = try await fetchSpecies(for: pokemon) else { return nil }
        
        guard let evolution = try await fetchEvolution(for: species) else { return nil }
        
        let types: [PKMType] = try await fetchTypes(for: pokemon)
        
        return CurrentPokemon(
            details: pokemon,
            species: species,
            evolution: evolution,
            types: types
        )
    }
    
    private func fetchPokemon(name: String) async throws -> PKMPokemon {
        try await pokemonService.fetchPokemon(name: name)
    }
    
    private func fetchSpecies(for pokemon: PKMPokemon) async throws -> PKMPokemonSpecies? {
        guard let resource = pokemon.species else { return nil }
        return try await pokemonService.fetchSpecies(resource: resource)
    }
    
    private func fetchEvolution(for species: PKMPokemonSpecies) async throws -> [EvolutionStage]? {
        guard let resource = species.evolutionChain else { return nil }
        return try await pokemonService.fetchEvolutionChain(resource: resource)
    }
    
    private func fetchTypes(for pokemon: PKMPokemon) async throws -> [PKMType] {
        guard let pokemonTypes = pokemon.types else { return [] }

        var types: [PKMType] = []

        for t in pokemonTypes {
            guard let typeResource = t.type else { continue }
            let typeDetails = try await pokemonService.fetchType(resource: typeResource)
            types.append(typeDetails)
        }
        return types
    }
}
