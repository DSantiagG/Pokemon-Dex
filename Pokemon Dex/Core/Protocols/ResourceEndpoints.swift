//
//  ResourceEndpoints.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//
import PokemonAPI

protocol ResourceEndpoints {
    associatedtype Item: Decodable

    static func fetchPage(_ state: PaginationState<Item>) async throws -> PKMPagedObject<Item>
    static func fetchByName(_ name: String) async throws -> Item
}
