//
//  PagedResourceService.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//


protocol PagingService<Item> {
    associatedtype Item
    
    func fetchInitialPage() async throws -> [Item]
    func fetchNextPage() async throws -> [Item]?
}
