//
//  PokemonSearchViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 22/11/25.
//

import Foundation
import PokemonAPI
import Combine

@MainActor
class PokemonSearchViewModel: ObservableObject, ErrorHandleable {
    
    // MARK: - Outputs
    @Published private(set) var filteredPokemons: [PKMPokemon] = []
    @Published var state: ViewState = .idle
    
    // MARK: - Dependencies
    private let pokemonService: PokemonService
    
    // MARK: - Debounce
    private var debounceTask: Task<Void, Never>?
    
    // MARK: - Token anti-race-condition
    private var searchToken = UUID()
    
    private var allPokemonResources: [PKMAPIResource<PKMPokemon>] = []
    private var currentSearchTask: Task<Void, Never>?
    
    // MARK: - Init
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
        if allPokemonResources.isEmpty {
            Task { @MainActor in
                await loadAllPokemonResources()
            }
        }
    }
    
    // MARK: - Debounce
    func search(_ term: String) {
        debounceTask?.cancel()

        debounceTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 200_000_000) 

            guard !Task.isCancelled else { return }

            filter(searchText: term)
        }
    }
    
    // MARK: - Filtering
    private func filter(searchText: String) {
        
        guard !allPokemonResources.isEmpty else { return }
        
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        searchToken = UUID()
        let token = searchToken
        
        currentSearchTask?.cancel()
        currentSearchTask = Task { @MainActor in
            
            guard !term.isEmpty else {
                filteredPokemons = []
                state = .idle
                return
            }
            
            let matches = allPokemonResources.filter {
                $0.name?.localizedCaseInsensitiveContains(term) == true
            }
            
            guard !matches.isEmpty else {
                filteredPokemons = []
                state = .notFound
                return
            }
            
            state = .loading
            
            do {
                let pokemons = try await pokemonService.fetchPokemons(from: matches)
                guard token == searchToken else { return }
                filteredPokemons = pokemons
                state = .loaded
            }catch {
                handle(error: error, debugMessage: "Error loading filtered pokemons", userMessage: "Oops! An error occured while searching your pokemon. Please try again!") { [weak self] in
                    self?.filter(searchText: term)
                }
                filteredPokemons = []
            }
        }
    }
    
    private func loadAllPokemonResources() async {
        print("Loading all pokemon resources...")
        state = .loading
        do{
            allPokemonResources = try await pokemonService.fetchAllPokemonResources()
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading all pokemon resources failed", userMessage: "Oops! We are having some troubles. Please try again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadAllPokemonResources()
                }
            }
        }
    }
}
