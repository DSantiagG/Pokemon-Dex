//
//  PokemonHomeViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import Foundation
import PokemonAPI
import Combine

enum PokemonBrowseMode {
    case all
    case filteredByTypes
    case favorites
}

struct PokemonTypeFilterItem: Identifiable, Hashable {
    let id: String
    let displayName: String
}

@MainActor
class PokemonHomeViewModel: PaginationViewModel<PKMPokemon, PokemonService> {
    
    @Published var browseMode: PokemonBrowseMode = .all {
        didSet {
            Task { @MainActor in
                await handleBrowseModeChange()
            }
        }
    }
    @Published var favoritePokemons: [PKMPokemon] = []
    @Published var filteredPokemons: [PKMPokemon] = []
    
    @Published var selectedTypes: [String] = []
    @Published var showFiltersError = false
    
    // MARK: - Type Resources
    private var typeResources: [PKMAPIResource<PKMType>]?
    
    override init(service: PokemonService, layoutKey: ListLayoutKey) {
        super.init(service: service, layoutKey: layoutKey)
        Task { @MainActor in
            await loadTypeResources()
        }
    }
    
    func toggleFavorites () {
        browseMode = browseMode == .favorites ? .all : .favorites
    }
    
    func loadFavoritePokemons() async {
        state = .loading
        do {
            favoritePokemons = try await service.fetchFavoritePokemons()
            state = favoritePokemons.isEmpty ? .notFound : .loaded
        } catch {
            handle(
                error: error,
                debugMessage: "Failed to load favorite Pokémons",
                userMessage: "We couldn't load your favorite Pokémon. Please try again."
            ) { [weak self] in
                Task { @MainActor in
                    await self?.loadFavoritePokemons()
                }
            }
        }
    }
    
    
    func filterPokemons() async {
        
        guard !selectedTypes.isEmpty else {
            filteredPokemons = []
            browseMode = .all
            return
        }
        guard let typeResources else {
            showFiltersError = true
            return
        }
        
        let selectedTypeResources = typeResources.filter { selectedTypes.contains($0.resourceName) }
        
        browseMode = .filteredByTypes
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
                    await self?.filterPokemons()
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
    
    func refreshIfNeededOnAppear() async {
        if browseMode == .favorites {
            await loadFavoritePokemons()
        }
    }

    private func handleBrowseModeChange() async {
        switch browseMode {
        case .favorites:
            await loadFavoritePokemons()
        case .all:
            state = items.isEmpty ? .notFound : .loaded
        case .filteredByTypes:
            break
        }
    }
}

extension PokemonHomeViewModel {
    
    var displayPokemons: [PKMPokemon] {
        switch browseMode {
        case .all:
            return items
        case .filteredByTypes:
            return filteredPokemons
        case .favorites:
            return favoritePokemons
        }
    }
    
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
