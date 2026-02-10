//
//  PaginationViewMode.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//
import Foundation
import Combine

/// Generic view model that manages paginated loading of resources.
///
/// `PaginationViewModel` is a reusable, MainActor-bound view model for lists that
/// support initial load + pagination. It delegates network work to a `Service`
/// conforming to ``PagingService`` and persists a ``ListLayout`` choice via a
/// `ListLayoutStorageProtocol` keyed by `layoutKey`.
///
/// - Generic parameters:
///   - Resource: The resource model type (must conform to ``IdentifiableResource``).
///   - Service: The paging service implementation used to fetch pages of `Resource`.
///
/// Example:
/// ```swift
/// let vm = PaginationViewModel(service: DataProvider.shared.pokemonService, layoutKey: .pokemon)
/// Task { await vm.loadInitialPage() }
/// ```
@MainActor
class PaginationViewModel<Resource: IdentifiableResource, Service: PagingService<Resource>>: ObservableObject, ErrorHandleable {
    
    // MARK: - Published state

    /// Currently loaded items presented by the view model.
    @Published var items: [Resource] = []
    /// Current view state used to show loading/error/empty UI.
    @Published var state: ViewState = .idle
    
    /// Currently selected layout for presenting the list.
    ///
    /// When changed the new layout is persisted using `layoutStorage` and
    /// `layoutKey` so the user's preference is remembered.
    @Published var layout: ListLayout {
        didSet {
            layoutStorage.setLayout(layout, for: layoutKey)
        }
    }
    
    // MARK: - Dependencies
    
    /// Service responsible for fetching pages of `Resource`.
    let service: Service
    /// Key that identifies which layout preference this view model controls.
    private let layoutKey: ListLayoutKey
    /// Storage abstraction used to persist and restore the `layout` preference.
    private let layoutStorage: ListLayoutStorageProtocol
    
    // MARK: - Initialization
    
    /// Create a new pagination view model.
    ///
    /// - Parameters:
    ///   - service: The paging service that performs network/data requests.
    ///   - layoutKey: The key used to read/write the user's preferred list layout.
    init(service: Service, layoutKey: ListLayoutKey) {
        self.service = service
        self.layoutKey = layoutKey
        // Obtain the shared layout storage from the app-wide DataProvider.
        self.layoutStorage = DataProvider.shared.listLayoutStorage
        // Restore the stored layout (or use the default provided by storage).
        self.layout = layoutStorage.getLayout(for: layoutKey)
    }
    
    // MARK: - Loading
    
    /// Load the first page of items and update `state` accordingly.
    ///
    /// On success `items` is replaced with the first page. On failure the error
    /// is passed to `handle(...)` which will surface a user-friendly message and
    /// offer a retry action.
    func loadInitialPage() async {
        state = .loading
        do {
            items = try await service.fetchInitialPage(limit: 20)
            state = items.isEmpty ? .notFound : .loaded
        } catch {
            handle(
                error: error,
                debugMessage: "Failed to load first page",
                userMessage: "Oops! We couldn't load the initial content. Please try again!."
            ) { [weak self] in
                Task { @MainActor in
                    await self?.loadInitialPage()
                }
            }
        }
    }
    
    /// Load the next page when the user scrolls near the end of the currently loaded items.
    ///
    /// - Parameter item: The item that triggered the pagination check (typically the last visible item).
    func loadNextPageIfNeeded(item: Resource) async {
        // Ensure the triggered item is the current list tail to avoid duplicate requests
        guard let last = items.last, last.resourceName == item.resourceName else { return }
        state = .loading
        do {
            if let newItems = try await service.fetchNextPage() {
                items.append(contentsOf: newItems)
            }
            state = .loaded
        } catch {
            handle(error: error,
                   debugMessage: "Pagination error",
                   userMessage: "We couldn’t load more content at the moment. Please try again."
            ) { [weak self] in
                Task { @MainActor in
                    await self?.loadNextPageIfNeeded(item: item)
                }
            }
        }
    }
}
