//
//  NavigationContext.swift
//  Pokemon Dex
//
//  Created by David Giron on 4/12/25.
//


enum NavigationContext {
    case main
    case sheet(SheetKind)

    enum SheetKind {
        case pokemon
        case ability
        case item
    }
}
