//
//  AbilityHomeViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 3/12/25.
//

import Foundation
import PokemonAPI
import Combine

@MainActor
class AbilityHomeViewModel: ObservableObject, ErrorHandleable {
    
    @Published var abilities: [PKMAbility] = []
    @Published var state: ViewState = .idle
    
    private let abilityService: AbilityService
    
    init(abilityService: AbilityService) {
        self.abilityService = abilityService
    }
    
    func loadInitialPage() async {
        print("Loading first ability page...")
        state = .loading
        
        do {
            abilities = try await abilityService.fetchInitialPage()
            if abilities.isEmpty {
                state = .notFound
            } else {
                state = .loaded
            }
        } catch {
            handle(error: error, debugMessage: "Loading first ability page failed", userMessage: "Oops! The Abilities list is having trouble loading. Please try again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadInitialPage()
                }
            }
        }
    }
    
    func loadNextPageIfNeeded(ability: PKMAbility) async {
        guard let last = abilities.last,
              last.name == ability.name else { return }
        
        state = .loading
        print("Loading next page...")
        
        do {
            if let newAbilities = try await abilityService.fetchNextPage() {
                self.abilities.append(contentsOf: newAbilities)
            }
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Pagination error", userMessage: "Looks like the next batch of Abilities couldn't be loaded. Try again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadNextPageIfNeeded(ability: ability)
                }
            }
        }
    }
}
