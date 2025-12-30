//
//  PaginationViewMode.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//
import Foundation
import Combine

@MainActor
class PaginationViewModel<Resource: IdentifiableResource, Service: PagingService<Resource>>: ObservableObject, ErrorHandleable {
    
    @Published var items: [Resource] = []
    @Published var state: ViewState = .idle
    
    @Published var layout: ListLayout {
        didSet {
            layoutStorage.setLayout(layout, for: layoutKey)
        }
    }
    
    let service: Service
    private let layoutKey: ListLayoutKey
    private let layoutStorage: ListLayoutStorageProtocol
    
    init(service: Service, layoutKey: ListLayoutKey) {
        self.service = service
        self.layoutKey = layoutKey
        self.layoutStorage = DataProvider.shared.listLayoutStorage
        self.layout = layoutStorage.getLayout(for: layoutKey)
    }
    
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
    
    func loadNextPageIfNeeded(item: Resource) async {
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
