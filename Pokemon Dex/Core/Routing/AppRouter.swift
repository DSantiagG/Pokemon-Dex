//
//  AppRouter.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//

import Combine

/// Central application router that exposes feature-specific ``NavigationRouter``s.
///
/// `AppRouter` provides shared ``NavigationRouter`` instances used by views and
/// view models to perform navigation throughout the app. Routers are exposed as
/// `@Published` properties so SwiftUI views can observe changes when needed.
///
/// Example:
/// ```swift
/// let appRouter = AppRouter.shared
/// // Push a Pokémon detail from the pokemon router (example API)
/// appRouter.pokemonRouter.push(.pokemonDetail(name: "bulbasaur"))
/// ```
@MainActor
final class AppRouter: ObservableObject {

    // MARK: - Shared Instance

    /// Global shared `AppRouter` used across the application.
    static let shared = AppRouter()

    // MARK: - Feature Routers

    /// Router used for Pokémon feature navigation.
    @Published var pokemonRouter = NavigationRouter()
    /// Router used for Ability feature navigation.
    @Published var abilityRouter = NavigationRouter()
    /// Router used for Item feature navigation.
    @Published var itemRouter = NavigationRouter()

    // MARK: - Search Routers

    /// Router used for Pokémon search navigation.
    @Published var pokemonSearchRouter = NavigationRouter()
    /// Router used for Ability search navigation.
    @Published var abilitySearchRouter = NavigationRouter()
    /// Router used for Item search navigation.
    @Published var itemSearchRouter = NavigationRouter()
}
