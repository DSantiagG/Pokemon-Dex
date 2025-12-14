//
//  ListLayoutKey.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//


enum ListLayoutKey: String {
    case pokemon = "layout.pokemon"
    case ability = "layout.ability"
    case item = "layout.item"
    
    var defaultLayout: ListLayout {
        switch self {
        case .pokemon, .item:
            return .twoColumns
        case .ability:
            return .singleColumn
        }
    }
}
