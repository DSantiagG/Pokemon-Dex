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
            handleError(message: "Loading first page failed", error: error) { [weak self] in
                Task { @MainActor in
                    await self?.loadInitialPage()
                }
            }
        }
    }
    
    func loadNextPageIfNeeded(currentPokemon: PKMPokemon) async {
        do {
            if let newPokemons = try await service.fetchNextPageIfNeeded(currentPokemon: currentPokemon, currentList: pokemons) {
                state = .loading
                print("Loading next page...")
                self.pokemons.append(contentsOf: newPokemons)
                state = .loaded
            }
        } catch {
            handleError(message: "Pagination error", error: error) { [weak self] in
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
            handleError(message: "Loading pokemon with name : \(name) failed", error: error) { [weak self] in
                Task { @MainActor in
                    await self?.loadPokemonIfNeeded(name: name)
                }
                
            }
        }
    }
    
    private func handleError(message: String, error: Error, retry: @escaping () -> Void) {
        print("\(message): \(error.localizedDescription)")
        state = .error(message: error.localizedDescription, retryAction: retry)
    }
}
