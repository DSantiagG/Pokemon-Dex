//
//  ItemDetailViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import Foundation
import Combine

import PokemonAPI

class ItemDetailViewModel: ObservableObject, ErrorHandleable{
    
    // MARK: - Published
    @Published var currentItem: CurrentItem?
    @Published var state: ViewState = .idle
    
    // MARK: - Services
    private let itemService: ItemService
    private let pokemonService: PokemonService
    
    // MARK: - Init
    init(itemService: ItemService, pokemonService: PokemonService) {
        self.itemService = itemService
        self.pokemonService = pokemonService
    }
    
    // MARK: - Public
    func loadItem(name: String) async {
        
        state = .loading
        currentItem = nil
        
        do{
            currentItem = try await fetchAllItemData(name: name)
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading item with name : \(name) failed", userMessage: "Something went wrong while loading this item. Tap retry to check again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadItem(name: name)
                }
            }
            currentItem = nil
        }
    }
    
    // MARK: - Private
    private func fetchAllItemData(name: String) async throws -> CurrentItem? {
        
        let item = try await fetchItem(name: name)

        guard let pokemons = try await fetchPokemons(for: item) else { return nil }

        return CurrentItem(
            details: item,
            holdingPokemon: pokemons
        )
    }
    
    private func fetchItem(name: String) async throws -> PKMItem {
        try await itemService.fetch(byName: name)
    }
    
    private func fetchPokemons(for item: PKMItem) async throws -> [PKMPokemon]? {
        guard let pokemons = item.heldByPokemon else { return nil }
        
        let pokemonResources: [PKMAPIResource<PKMPokemon>] = pokemons.compactMap { $0.pokemon }
        return try await pokemonService.fetch(from: pokemonResources)
    }
}
