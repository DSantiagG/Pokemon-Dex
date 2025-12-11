//
//  SearchService.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//

protocol SearchService {
    associatedtype Item
    associatedtype Resource: IdentifiableResource
    
    func fetchAllResources() async throws -> [Resource]
    func fetch(from resources: [Resource]) async throws -> [Item]
}
