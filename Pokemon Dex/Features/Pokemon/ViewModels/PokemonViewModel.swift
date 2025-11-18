//
//  PokemonViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import Foundation
import PokemonAPI
import Combine

struct CurrentPokemon {
    var details: PKMPokemon
    var species: PKMPokemonSpecies
    var evolution: [EvolutionStage]
    var types: [PKMType]
}

@MainActor
class PokemonViewModel: ObservableObject, ErrorHandleable {
    
    @Published var pokemons: [PKMPokemon] = []
    @Published var currentPokemon: CurrentPokemon?
    
    @Published var state: ViewState = .idle
    @Published var pokemonNotFound: Bool = false
    
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    func loadInitialPage() async {
        print("Loading first page...")
        state = .loading
        
        do {
            pokemons = try await pokemonService.fetchInitialPage()
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading first page failed", userMessage: "Oops! The Pokédex is having trouble loading your Pokémon. Please try again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadInitialPage()
                }
            }
        }
    }
    
    func loadNextPageIfNeeded(pokemon: PKMPokemon) async {
        
        guard let last = pokemons.last,
              last.name == pokemon.name else {return}
        
        state = .loading
        print("Loading next page...")
        
        do {
            if let newPokemons = try await pokemonService.fetchNextPage() {
                self.pokemons.append(contentsOf: newPokemons)
                state = .loaded
            }
        } catch {
            handle(error: error, debugMessage: "Pagination error", userMessage: "Looks like the next batch of Pokémon ran away. Try again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadNextPageIfNeeded(pokemon: pokemon)
                }
            }
        }
    }
    
    func loadPokemon(name: String) async {
        
        state = .loading
        pokemonNotFound = false
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
        }
    }
    
    private func fetchAllPokemonData(name: String) async throws -> CurrentPokemon? {
        
        let pokemon = try await pokemonService.fetchPokemon(name: name)
        
        guard let speciesResource = pokemon.species else { return nil }
        
        let species = try await pokemonService.fetchSpecies(resource: speciesResource)
        
        guard let evolutionResource = species.evolutionChain else { return nil }
        
        guard let evolution = try await pokemonService.fetchEvolutionChain(resource: evolutionResource) else { return nil }
        
        var types: [PKMType] = []
        if let pokemonTypes = pokemon.types{
            for pokemonType in pokemonTypes {
                guard let type = pokemonType.type else { continue }
                let typePokemon = try await pokemonService.fetchType(resource: type)
                types.append(typePokemon)
            }
        }
        
        return CurrentPokemon(
            details: pokemon,
            species: species,
            evolution: evolution,
            types: types
        )
    }
    
    func setNotFoundAndClear() {
        pokemonNotFound = true
        currentPokemon = nil
    }
}
