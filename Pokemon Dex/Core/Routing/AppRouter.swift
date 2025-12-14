//
//  AppRouter.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import Combine

@MainActor
final class AppRouter: ObservableObject {
    
    static let shared = AppRouter()
    
    @Published var pokemonRouter = NavigationRouter()
    @Published var abilityRouter = NavigationRouter()
    @Published var itemRouter = NavigationRouter()
    
    @Published var pokemonSearchRouter = NavigationRouter()
    @Published var abilitySearchRouter = NavigationRouter()
    @Published var itemSearchRouter = NavigationRouter()
    
    @Published var sheetRouter = NavigationRouter()
}
