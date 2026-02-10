//
//  SearchViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//
import Combine
import Foundation

/// View model that performs client-side search using a `SearchService`.
///
/// The view model loads the full resource index on init, debounces user input,
/// and executes filtered searches against the preloaded resource list. Results
/// are published via `results` and loading/error state through `state`.
///
/// - Generic parameter `S`: A ``SearchService`` implementation providing
///   methods to fetch resources and decode models.
///
/// Example:
/// ```swift
/// let vm = SearchViewModel(service: DataProvider.shared.pokemonService)
/// vm.search("pikachu")
/// ```
@MainActor
class SearchViewModel<S: SearchService>: ObservableObject, ErrorHandleable {
    
    // MARK: - Outputs
    /// Current search results produced by the last successful query.
    @Published private(set) var results: [S.Item] = []
    /// Current UI state (idle/loading/loaded/notFound/error) exposed to the view.
    @Published var state: ViewState = .idle
    
    // MARK: - Dependencies
    /// Service used to fetch models for matching resources and to load the resource index.
    private let service: S
    
    // MARK: - Debounce & Tasks
    /// Short-lived task used to debounce frequent user input before filtering.
    private var debounceTask: Task<Void, Never>?
    /// The currently active search task; cancelled when a newer search starts.
    private var currentSearchTask: Task<Void, Never>?
    
    // MARK: - Token
    /// A token used to ignore results from stale async searches.
    private var searchToken = UUID()
    
    // MARK: - Resources
    /// Full list of resource descriptors used to filter locally before fetching models.
    private var allResources: [S.Resource] = []
    
    // MARK: - Init
    /// Create a search view model with the provided service.
    ///
    /// - Parameter service: An implementation of `SearchService` used to load resources and models.
    init(service: S) {
        self.service = service
        Task { @MainActor in
            await loadAllResources()
        }
    }
    
    // MARK: - Public search
    /// Schedule a debounced search for `term`.
    ///
    /// This method cancels any previous debounce and starts a short delay (200ms)
    /// before running the filtering logic to avoid running searches on every keystroke.
    ///
    /// - Parameter term: Raw user-entered search string.
    func search(_ term: String) {
        debounceTask?.cancel()
        debounceTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 200_000_000)
            guard !Task.isCancelled else { return }
            filter(searchText: term)
        }
    }
    
    // MARK: - Filtering logic
    /// Filter the preloaded `allResources` using `searchText`, then fetch matching models.
    ///
    /// - Parameter searchText: The trimmed search string used to match resource names.
    private func filter(searchText: String) {
        
        guard !allResources.isEmpty else { return }
        
        let term = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !term.isEmpty else {
            results = []
            state = .idle
            return
        }
        
        // Replace the search token to invalidate previous results when new search begins
        searchToken = UUID()
        let token = searchToken
        
        currentSearchTask?.cancel()
        currentSearchTask = Task { @MainActor in
            
            // Perform local filtering first to avoid unnecessary network requests
            let matches = allResources.filter { resource in
                resource.resourceName.formattedName().localizedCaseInsensitiveContains(term) == true
            }
            
            guard !matches.isEmpty else {
                results = []
                state = .notFound
                return
            }
            
            state = .loading
            
            do {
                // Fetch the concrete model instances for the matched resources
                let items = try await service.fetch(from: matches)
                // Ensure the results still correspond to the latest search
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
    /// Load the full resource index used for client-side filtering.
    ///
    /// This method is called during initialization and will populate `allResources`.
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
