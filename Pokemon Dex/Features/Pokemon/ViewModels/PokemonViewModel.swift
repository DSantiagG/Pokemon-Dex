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
    var pokemon: PKMPokemon
    var species: PKMPokemonSpecies
    var evolution: [EvolutionStage]
}

@MainActor
class PokemonViewModel: ObservableObject, HasViewState {
    
    @Published var pokemons: [PKMPokemon] = []
    @Published var currentPokemon: CurrentPokemon?
    
    @Published var state: ViewState = .idle
    @Published var pokemonNotFound: Bool = false
    
    private let service = PokemonService()
    
    func loadInitialPage() async {
        print("Loading first page...")
        state = .loading
        
        do {
            pokemons = try await service.fetchInitialPage()
            state = .loaded
        } catch {
            handleError(debugMessage: "Loading first page failed", message: "Oops! The Pokédex is having trouble loading your Pokémon. Please try again!", error: error) { [weak self] in
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
            if let newPokemons = try await service.fetchNextPage() {
                self.pokemons.append(contentsOf: newPokemons)
                state = .loaded
            }
        } catch {
            handleError(debugMessage: "Pagination error", message: "Looks like the next batch of Pokémon ran away. Try again!", error: error) { [weak self] in
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
            if let httpError = error as? HTTPError {
                let handled = handleHTTPError(httpError)
                if handled { return }
            }
            
            handleError(debugMessage: "Loading pokemon with name : \(name) failed", message: "This Pokémon is hiding… tap retry to find it!", error: error) { [weak self] in
                Task { @MainActor in
                    await self?.loadPokemon(name: name)
                }
            }
        }
    }
    
    private func fetchAllPokemonData(name: String) async throws -> CurrentPokemon? {
        
        let pokemon = try await service.fetchPokemon(name: name)
        
        guard let speciesResource = pokemon.species else { return nil }
        
        let species = try await service.fetchSpecies(resource: speciesResource)
        
        guard let evolutionResource = species.evolutionChain else { return nil }
        
        guard let evolution = try await service.fetchEvolutionChain(resource: evolutionResource) else { return nil }
        
        return CurrentPokemon(
            pokemon: pokemon,
            species: species,
            evolution: evolution
        )
    }
    
    private func handleHTTPError(_ httpError: HTTPError) -> Bool {
        switch httpError {
        case .serverResponse(let code, _):
            if code == .notFound {
                self.pokemonNotFound = true
                self.state = .loaded
                self.currentPokemon = nil
                return true
            }
        default:
            break
        }
        
        return false
    }
    
    private func handleError(debugMessage: String, message: String, error: Error, retry: @escaping () -> Void) {
        print("\(debugMessage): \(error.localizedDescription)")
        state = .error(message: message, retryAction: retry)
    }
}
