//
//  PaginationViewMode.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//
import Foundation
import Combine

@MainActor
class PaginationViewModel<Resource: IdentifiableResource>: ObservableObject, ErrorHandleable {
    
    @Published var items: [Resource] = []
    @Published var state: ViewState = .idle
    
    private let service: any PagingService<Resource>
    
    init(service: any PagingService<Resource>) {
        self.service = service
    }
    
    func loadInitialPage() async {
        state = .loading
        do {
            items = try await service.fetchInitialPage()
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
