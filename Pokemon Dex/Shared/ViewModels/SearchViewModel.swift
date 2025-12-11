//
//  SearchViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//
import Combine
import Foundation

@MainActor
class SearchViewModel<S: SearchService>: ObservableObject, ErrorHandleable {
    
    // MARK: - Outputs
    @Published private(set) var results: [S.Item] = []
    @Published var state: ViewState = .idle
    
    // MARK: - Dependencies
    private let service: S
    
    // MARK: - Debounce
    private var debounceTask: Task<Void, Never>?
    private var currentSearchTask: Task<Void, Never>?
    
    // MARK: - Token
    private var searchToken = UUID()
    
    // MARK: - Resources
    private var allResources: [S.Resource] = []
    
    init(service: S) {
        self.service = service
        Task { @MainActor in
            await loadAllResources()
        }
    }
    
    // MARK: - Public search
    func search(_ term: String) {
        debounceTask?.cancel()
        debounceTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 200_000_000)
            guard !Task.isCancelled else { return }
            filter(searchText: term)
        }
    }
    
    // MARK: - Filtering logic
    private func filter(searchText: String) {
        
        guard !allResources.isEmpty else { return }
        
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !term.isEmpty else {
            results = []
            state = .idle
            return
        }
        
        searchToken = UUID()
        let token = searchToken
        
        currentSearchTask?.cancel()
        currentSearchTask = Task { @MainActor in
            
            let matches = allResources.filter { resource in
                resource.resourceName.localizedCaseInsensitiveContains(term) == true
            }
            
            guard !matches.isEmpty else {
                results = []
                state = .notFound
                return
            }
            
            state = .loading
            
            do {
                let items = try await service.fetch(from: matches)
                guard token == searchToken else { return }
                results = items
                state = .loaded
            } catch {
                handle(
                    error: error,
                    debugMessage: "Error loading search results",
                    userMessage: "Oops! Something went wrong. Please try again!."
                ) { [weak self] in
                    self?.filter(searchText: term)
                }
                results = []
            }
        }
    }
    
    // MARK: - Load all resources
    private func loadAllResources() async {
        state = .loading
        do {
            allResources = try await service.fetchAllResources()
            state = .loaded
        } catch {
            handle(
                error: error,
                debugMessage: "Failed to load resources",
                userMessage: "There was a problem starting your search. Please try again!"
            ) { [weak self] in
                Task { @MainActor in
                    await self?.loadAllResources()
                }
            }
        }
    }
}
