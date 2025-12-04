//
//  PokemonHomeViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import Foundation
import PokemonAPI
import Combine

@MainActor
class PokemonHomeViewModel: ObservableObject, ErrorHandleable {
    
    @Published var pokemons: [PKMPokemon] = []
    @Published var state: ViewState = .idle
    
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    func loadInitialPage() async {
        print("Loading first pokemon page...")
        state = .loading
        
        do {
            pokemons = try await pokemonService.fetchInitialPage()
            if pokemons.isEmpty{
                state = .notFound
            }else{
                state = .loaded
            }
        } catch {
            handle(error: error, debugMessage: "Loading first pokemon page failed", userMessage: "Oops! The Pokédex is having trouble loading your Pokémon. Please try again!") { [weak self] in
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
            }
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Pagination error", userMessage: "Looks like the next batch of Pokémon ran away. Try again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadNextPageIfNeeded(pokemon: pokemon)
                }
            }
        }
    }
}
