//
//  AppTap.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/12/25.
//


enum AppTab: Hashable {
    case pokemon
    case items
    case abilities
    case search
    
    var title: String {
        switch self {
        case .pokemon: return "Pokémon"
        case .items: return "Items"
        case .abilities: return "Abilities"
        case .search: return "Search"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .pokemon: return "circle.circle.fill"
        case .items: return "leaf.circle.fill"
        case .abilities: return "bolt.circle.fill"
        case .search: return "magnifyingglass"
        }
    }
}
