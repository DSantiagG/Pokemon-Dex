//
//  AbilityDetailViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import Combine

import PokemonAPI

class AbilityDetailViewModel: ObservableObject, ErrorHandleable {
    
    // MARK: - Published
    @Published var currentAbility: CurrentAbility?
    @Published var state: ViewState = .idle
    
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
        currentAbility = nil
        
        do{
            currentAbility = try await fetchAllAbilityData(name: name)
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading ability with name : \(name) failed", userMessage: "Something went wrong while loading this ability. Tap retry to check again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadAbility(name: name)
                }
            }
            currentAbility = nil
        }
    }
    
    // MARK: - Private
    private func fetchAllAbilityData(name: String) async throws -> CurrentAbility? {
        
        let ability = try await fetchAbility(name: name)

        let (normal, hidden) = try await fetchPokemons(for: ability)
        
        guard let normal else { return nil }
        guard let hidden else { return nil }

        return CurrentAbility(
            details: ability,
            normalPokemons: normal,
            hiddenPokemons: hidden
        )
    }
    
    private func fetchAbility(name: String) async throws -> PKMAbility {
        try await abilityService.fetch(byName: name)
    }
    
    private func fetchPokemons(for ability: PKMAbility) async throws -> (normal: [PKMPokemon]?, hidden: [PKMPokemon]?) {

        guard let abilityPokemons = ability.pokemon else { return (nil, nil) }

        var normalPokemons: [PKMPokemon] = []
        var hiddenPokemons: [PKMPokemon] = []

        try await withThrowingTaskGroup(of: (isHidden: Bool, pokemon: PKMPokemon)?.self) { group in
            for abilityPokemon in abilityPokemons {
                group.addTask { [pokemonService] in
                    guard let resource = abilityPokemon.pokemon else { return nil }
                    let pokemon = try await pokemonService.fetch(resource: resource)
                    return (abilityPokemon.isHidden ?? false, pokemon)
                }
            }
            for try await result in group {
                guard let result else { continue }

                if result.isHidden {
                    hiddenPokemons.append(result.pokemon)
                } else {
                    normalPokemons.append(result.pokemon)
                }
            }
        }
        return (normalPokemons, hiddenPokemons)
    }
}
