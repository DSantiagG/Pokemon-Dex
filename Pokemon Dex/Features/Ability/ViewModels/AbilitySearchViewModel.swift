//
//  AbilitySearchViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 5/12/25.
//

import Foundation
import PokemonAPI
import Combine

@MainActor
class AbilitySearchViewModel: ObservableObject, ErrorHandleable {
    
    // MARK: - Outputs
    @Published private(set) var filteredAbilities: [PKMAbility] = []
    @Published var state: ViewState = .idle
    
    // MARK: - Dependencies
    private let abilityService: AbilityService
    
    // MARK: - Debounce
    private var debounceTask: Task<Void, Never>?
    
    // MARK: - Token anti-race-condition
    private var searchToken = UUID()
    
    private var allAbilityResources: [PKMAPIResource<PKMAbility>] = []
    private var currentSearchTask: Task<Void, Never>?
    
    // MARK: - Init
    init(abilityService: AbilityService) {
        self.abilityService = abilityService
        if allAbilityResources.isEmpty {
            Task { @MainActor in
                await loadAllAbilityResources()
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
        
        guard !allAbilityResources.isEmpty else { return }
        
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        searchToken = UUID()
        let token = searchToken
        
        currentSearchTask?.cancel()
        currentSearchTask = Task { @MainActor in
            
            guard !term.isEmpty else {
                filteredAbilities = []
                state = .idle
                return
            }
            
            let matches = allAbilityResources.filter {
                $0.name?.localizedCaseInsensitiveContains(term) == true
            }
            
            guard !matches.isEmpty else {
                filteredAbilities = []
                state = .notFound
                return
            }
            
            state = .loading
            
            do {
                let abilities = try await abilityService.fetchAbilities(from: matches)
                guard token == searchToken else { return }
                filteredAbilities = abilities
                state = .loaded
            }catch {
                handle(error: error, debugMessage: "Error loading filtered abilities", userMessage: "Oops! An error occured while searching your ability. Please try again!") { [weak self] in
                    self?.filter(searchText: term)
                }
                filteredAbilities = []
            }
        }
    }
    
    private func loadAllAbilityResources() async {
        print("Loading all ability resources...")
        state = .loading
        do{
            allAbilityResources = try await abilityService.fetchAllAbilityResources()
            state = .loaded
        } catch {
            handle(error: error, debugMessage: "Loading all ability resources failed", userMessage: "Oops! We are having some troubles. Please try again!") { [weak self] in
                Task { @MainActor in
                    await self?.loadAllAbilityResources()
                }
            }
        }
    }
}
