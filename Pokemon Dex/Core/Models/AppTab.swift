//
//  AppTap.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/12/25.
//


enum AppTab: Hashable {
    case pokemon
    case abilities
    case berries
    case search
    
    var title: String {
        switch self {
        case .pokemon: return "Pokémon"
        case .abilities: return "Abilities"
        case .berries: return "Berries"
        case .search: return "Search"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .pokemon: return "circle.circle.fill"
        case .abilities: return "bolt.circle.fill"
        case .berries: return "leaf.circle.fill"
        case .search: return "magnifyingglass"
        }
    }
}
