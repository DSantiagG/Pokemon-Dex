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
class PokemonHomeViewModel: PaginationViewModel<PKMPokemon, PokemonService> {
    
    @Published var filteredPokemons: [PKMPokemon] = []
    @Published var showFiltersError = false
    
    /// True only when filters are applied AND results exist
    var showFilteredResults: Bool { !filteredPokemons.isEmpty }
    
    // MARK: - Type Resources
    private var typeResources: [PKMAPIResource<PKMType>]?
    
    override init(service: PokemonService, layoutKey: ListLayoutKey) {
        super.init(service: service, layoutKey: layoutKey)
        Task { @MainActor in
            await loadTypeResources()
        }
    }
    
    func filterPokemons(byTypes types: [String]) async {
        
        guard !types.isEmpty else {
            filteredPokemons = []
            state = items.isEmpty ? .notFound : .loaded
            return
        }
        guard let typeResources else {
            showFiltersError = true
            return
        }
        
        let selectedTypeResources = typeResources.filter { types.contains($0.resourceName) }
        state = .loading
        
        do {
            filteredPokemons = try await service.fetch(byTypes: selectedTypeResources)
            state = filteredPokemons.isEmpty ? .notFound : .loaded
        } catch {
            handle(
                error: error,
                debugMessage: "Failed to filter pokemons",
                userMessage: "Oops! Something went wrong while filtering. Please try again!."
            ) { [weak self] in
                Task { @MainActor in
                    await self?.loadInitialPage()
                }
            }
        }
    }
    
    // MARK: - Load all resources
    func loadTypeResources() async {
        do {
            typeResources = try await service.fetchAllTypeResources()
            showFiltersError = false
        } catch {
            print("[DEBUG] Failed to load resources: \(error.localizedDescription)")
            typeResources = nil
        }
    }
}

extension PokemonHomeViewModel {
    
    private var fallbackTypes: [String] {
        ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "steel", "fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy", "stellar", "unknown"]
    }
    
    var displayTypes: [PokemonTypeFilterItem] {
        typeResources?
            .compactMap { resource in
                guard let name = resource.name else { return nil }
                return PokemonTypeFilterItem(
                    id: name,
                    displayName: name.formattedName()
                )
            }
        ?? fallbackTypes.map {
            PokemonTypeFilterItem(
                id: $0,
                displayName: $0.formattedName()
            )
        }
    }
}
