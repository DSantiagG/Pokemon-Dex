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
class PokemonViewModel: ObservableObject {
    
    @Published var pokemons: [PKMPokemon] = []
    @Published var state: LoadingState = .idle
    
    private var pagedObject: PKMPagedObject<PKMPokemon>?
    private let api = PokemonAPI()
    
    enum LoadingState {
        case idle
        case loading
        case loaded
        case error(message: String, source: ErrorSource)
        
        enum ErrorSource {
            case initial
            case pagination
        }
    }
    
    func loadInitialPage() async {
        switch state {
        case .idle, .error:
            break
        default:
            return
        }
        
        print("Loading first page...")
        state = .loading
        
        do {
            let result = try await api.pokemonService.fetchPokemonList(paginationState: .initial(pageLimit: 20))
            pagedObject = result
            pokemons = try await fetchPokemons(from: result.results ?? [])
            state = .loaded
        } catch {
            print("Loading first page failed:", error.localizedDescription)
            state = .error(message: error.localizedDescription, source: .initial)
        }
    }
    
    func loadNextPageIfNeeded(currentPokemon: PKMPokemon) async {
        guard let pagedObject = pagedObject,
              let last = pokemons.last,
              last.name == currentPokemon.name,
              pagedObject.hasNext else { return }
        
        print("Loading next page...")
        state = .loading
        
        do {
            let next = try await api.pokemonService.fetchPokemonList(paginationState: .continuing(pagedObject, .next))
            self.pagedObject = next
            let newPokemons = try await fetchPokemons(from: next.results ?? [])
            self.pokemons.append(contentsOf: newPokemons)
            state = .loaded
        } catch {
            print("Pagination error: \(error.localizedDescription)")
            state = .error(message: error.localizedDescription, source: .pagination)
        }
    }
    
    func fetchPokemonByName(name: String) async -> PKMPokemon?{
        do{
            let pokemon = try await api.pokemonService.fetchPokemon(name)
            return pokemon
        } catch {
            print("Fetching pokemon with name : \(name) failed: \(error.localizedDescription)")
        }
        return nil
    }
    
    private func fetchPokemons(from results: [PKMAPIResource<PKMPokemon>]) async throws -> [PKMPokemon] {
        var pokemons: [PKMPokemon] = []
        for result in results {
            if let name = result.name {
                let pokemon = try await api.pokemonService.fetchPokemon(name)
                pokemons.append(pokemon)
            }
        }
        return pokemons
    }
    
}
