//
//  PokemonViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import Foundation
import PokemonAPI
import Combine

@MainActor
class PokemonViewModel: ObservableObject, HasViewState {
    
    @Published var pokemons: [PKMPokemon] = []
    @Published var currentPokemon: PKMPokemon?
    @Published var state: ViewState = .idle
    
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
    
    func loadNextPageIfNeeded(currentPokemon: PKMPokemon) async {
        
        guard let last = pokemons.last,
            last.name == currentPokemon.name else {return}
        
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
                    await self?.loadNextPageIfNeeded(currentPokemon: currentPokemon)
                }
            }
        }
    }
    
    func loadPokemonIfNeeded(name: String) async {
        
        state = .loading
        
        do{
            if let found = pokemons.first(where: { $0.name == name }) {
                print("Getting pokemon from local")
                currentPokemon = found
            } else{
                print("Loading pokemon...")
                currentPokemon = try await service.fetchPokemon(name: name)
            }
            state = .loaded
        } catch {
            handleError(debugMessage: "Loading pokemon with name : \(name) failed", message: "This Pokémon is hiding… tap retry to find it!", error: error) { [weak self] in
                Task { @MainActor in
                    await self?.loadPokemonIfNeeded(name: name)
                }
                
            }
        }
    }
    
    private func handleError(debugMessage: String, message: String, error: Error, retry: @escaping () -> Void) {
        print("\(debugMessage): \(error.localizedDescription)")
        state = .error(message: message, retryAction: retry)
    }
}
