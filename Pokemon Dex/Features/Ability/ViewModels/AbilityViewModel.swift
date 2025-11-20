//
//  AbilityViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import PokemonAPI
import Combine


struct CurrentAbility {
    let details: PKMAbility
    let normalPokemons: [PKMPokemon]
    let hiddenPokemons: [PKMPokemon]
}

class AbilityViewModel: ObservableObject, ErrorHandleable {
    
    // MARK: - Published
    @Published var abilities: [PKMPokemon] = []
    @Published var currentAbility: CurrentAbility?
    
    @Published var state: ViewState = .idle
    @Published var abilityNotFound: Bool = false
    
    // MARK: - Services
    private let abilityService: AbilityService
    private let pokemonService: PokemonService
    
    // MARK: - Init
    init(abilityService: AbilityService, pokemonService: PokemonService) {
        self.abilityService = abilityService
        self.pokemonService = pokemonService
    }
    
    // MARK: - Public
    func loadAbility(name: String) async {
        
        state = .loading
        abilityNotFound = false
        currentAbility = nil
        
        do{
            currentAbility = try await fetchAllAbilityData(name: name)
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading ability with name : \(name) failed", userMessage: "Looks like this ability isn’t in the Dex… tap retry to check again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadAbility(name: name)
                }
            }
        }
    }
    
    private func fetchAllAbilityData(name: String) async throws -> CurrentAbility? {
        
        let ability = try await abilityService.fetchAbility(name: name)
        guard let abilityPokemons = ability.pokemon else { return nil }

        var normalPokemons: [PKMPokemon] = []
        var hiddenPokemons: [PKMPokemon] = []

        try await withThrowingTaskGroup(of: (isHidden: Bool, pokemon: PKMPokemon)?.self) { group in
            for abilityPokemon in abilityPokemons {
                group.addTask { [pokemonService] in
                    guard let pokemonResource = abilityPokemon.pokemon else { return nil }
                    
                    let pokemon = try await pokemonService.fetchPokemon(resource: pokemonResource)
                    return (abilityPokemon.isHidden ?? false, pokemon)
                }
            }

            for try await result in group {
                guard let result = result else { continue }
                if result.isHidden {
                    hiddenPokemons.append(result.pokemon)
                } else {
                    normalPokemons.append(result.pokemon)
                }
            }
        }

        return CurrentAbility(
            details: ability,
            normalPokemons: normalPokemons,
            hiddenPokemons: hiddenPokemons
        )
    }
    
    func setNotFoundAndClear() {
        abilityNotFound = true
        currentAbility = nil
    }
}

