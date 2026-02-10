//
//  PokemonHomeViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import Foundation
import PokemonAPI
import Combine

/// Modes used to control which Pokémon the home screen displays.
///
/// - `all`: Show the full paginated list.
/// - `filteredByTypes`: Show items matching the currently selected type filters.
/// - `favorites`: Show the user's favorite Pokémon.
///
/// Use this enum to switch the UI and data source for the list presentation.
enum PokemonBrowseMode {
    case all
    case filteredByTypes
    case favorites
}

/// Lightweight model used to populate type filter UI controls.
///
/// - Properties:
///   - `id`: The unique type identifier (slug) used as the `Identifiable` id.
///   - `displayName`: User-facing, formatted name for the type (e.g. "Fire").
struct PokemonTypeFilterItem: Identifiable, Hashable {
    let id: String
    let displayName: String
}

@MainActor
/// View model for the Pokémon home/browse screen supporting pagination, filtering and favorites.
///
/// Use `PokemonHomeViewModel` to load paged Pokémon (via the inherited `PaginationViewModel`),
/// switch between browsing modes (`all`, `filteredByTypes`, `favorites`), and manage the
/// client-side type filters and favorites list.
///
/// - Note: Network errors are surfaced via the `ErrorHandleable` helper used by the base class.
/// - Example:
/// ```swift
/// let vm = PokemonHomeViewModel(service: DataProvider.shared.pokemonService, layoutKey: .pokemon)
/// Task { await vm.loadInitialPage() }
/// ```
class PokemonHomeViewModel: PaginationViewModel<PKMPokemon, PokemonService> {
    
    // MARK: - Published state
    /// Current browsing mode (all, filteredByTypes, favorites).
    @Published var browseMode: PokemonBrowseMode = .all {
        didSet {
            Task { @MainActor in
                await handleBrowseModeChange()
            }
        }
    }
    /// Favorite Pokémon resolved from the favorites service.
    @Published var favoritePokemons: [PKMPokemon] = []
    /// Pokémon matching the currently selected type filters.
    @Published var filteredPokemons: [PKMPokemon] = []
    
    /// Currently selected type slugs used for filtering (e.g. ["fire", "flying"]).
    @Published var selectedTypes: [String] = []
    /// Flag indicating an error occurred while loading available filter resources.
    @Published var showFiltersError = false
    
    // MARK: - Type Resources
    /// Cached list of available type resource descriptors used to build the filter UI.
    private var typeResources: [PKMAPIResource<PKMType>]?
    
    // MARK: - Init
    /// Initialize and start loading auxiliary resources (types) in the background.
    override init(service: PokemonService, layoutKey: ListLayoutKey) {
        super.init(service: service, layoutKey: layoutKey)
        Task { @MainActor in
            await loadTypeResources()
        }
    }
    
    // MARK: - Actions
    /// Toggle the favorites browse mode on/off.
    ///
    /// - Behavior: When toggled to `.favorites` the view model will attempt to load the user's favorites.
    func toggleFavorites () {
        browseMode = browseMode == .favorites ? .all : .favorites
    }
    
    /// Load favorite Pokémon using the `PokemonService`.
    ///
    /// - Note: Errors are handled via `handle(...)` which will surface a user-friendly message and provide a retry action.
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
    
    /// Execute filtering using the selected type slugs.
    ///
    /// - Behavior: If `selectedTypes` is empty the view model resets to `.all` mode. If the required type resources
    ///   could not be loaded this method sets `showFiltersError = true` and returns.
    /// - Note: On success `filteredPokemons` is populated and `state` updated accordingly.
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
    /// Load type resource descriptors used to build filter controls.
    ///
    /// - Note: The method catches errors internally and sets `typeResources` to `nil` when loading fails.
    func loadTypeResources() async {
        do {
            typeResources = try await service.fetchAllTypeResources()
            showFiltersError = false
        } catch {
            print("[DEBUG] Failed to load resources: \(error.localizedDescription)")
            typeResources = nil
        }
    }
    
    /// Refresh favorites when the view appears if `browseMode == .favorites`.
    func refreshIfNeededOnAppear() async {
        if browseMode == .favorites {
            await loadFavoritePokemons()
        }
    }

    /// Respond to changes in `browseMode` to update content/state.
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
    
    /// Array of Pokémon that should currently be shown depending on `browseMode`.
    ///
    /// - Returns: The current list of `PKMPokemon` to present to the UI.
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
    
    /// Fallback list of type slugs used when the API type resources are unavailable.
    private var fallbackTypes: [String] {
        ["normal", "fighting", "flying", "poison", "ground", "rock", "bug", "ghost", "steel", "fire", "water", "grass", "electric", "psychic", "ice", "dragon", "dark", "fairy", "stellar", "unknown"]
    }
    
    /// Displayable type filter items used by the filter UI.
    ///
    /// - Returns: An array of `PokemonTypeFilterItem` (id + displayName) built from API resources or a fallback list when unavailable.
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
