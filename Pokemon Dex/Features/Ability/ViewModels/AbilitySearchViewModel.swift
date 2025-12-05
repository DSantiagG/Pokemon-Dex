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
    // MARK: - Inputs
    @Published var searchText: String = ""
    
    // MARK: - Outputs
    @Published private(set) var normalizedSearch: String = ""
    @Published private(set) var filteredAbilities: [PKMAbility] = []
    @Published var state: ViewState = .idle
    
    // MARK: - Dependencies
    private let abilityService: AbilityService
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
    
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
        
        setupSearchListener()
    }
    
    // MARK: - Combine Search Handler
    private func setupSearchListener() {
        $searchText
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.normalizedSearch = text
                self?.filterAbilities()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Filtering
    func filterAbilities() {
        
        guard !allAbilityResources.isEmpty else { return }
        
        let term = normalizedSearch
        
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
                    self?.filterAbilities()
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
