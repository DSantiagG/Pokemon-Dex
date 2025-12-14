//
//  ItemService.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import Foundation
import PokemonAPI

enum ItemEndpoints: ResourceEndpoints {
    static func fetchPage(_ state: PaginationState<PKMItem>) async throws -> PKMPagedObject<PKMItem> {
        try await PokemonAPI().itemService.fetchItemList(paginationState: state)
    }

    static func fetchByName(_ name: String) async throws -> PKMItem {
        try await PokemonAPI().itemService.fetchItem(name)
    }
}

typealias ItemService = ResourceService<ItemEndpoints>
