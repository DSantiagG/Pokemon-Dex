//
//  AppTap.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/12/25.
//
import SwiftUI

/// Represents a top-level application tab and provides UI information and routing helpers.
///
/// Use `AppTab` to access the tab title, system image and to obtain the view or search router
/// associated with each tab.
enum AppTab: Hashable {
    case pokemon
    case items
    case abilities
    case search

    /// The set of tabs considered primary in the app's main tab bar.
    static var primaryTabs: [AppTab] {
        [.pokemon, .items, .abilities]
    }

    // MARK: - UI
    /// The localized title displayed for the tab.
    var title: String {
        switch self {
        case .pokemon: return "Pokémon"
        case .items: return "Items"
        case .abilities: return "Abilities"
        case .search: return "Search"
        }
    }

    /// The SF Symbol name used as the tab's icon.
    var systemImageName: String {
        switch self {
        case .pokemon: return "circle.circle.fill"
        case .items: return "leaf.circle.fill"
        case .abilities: return "bolt.circle.fill"
        case .search: return "magnifyingglass"
        }
    }

    // MARK: - View
    /// The root view associated with this tab.
    ///
    /// - Parameter appRouter: An ``AppRouter`` providing routers for the child feature views.
    /// - Returns: A view configured with the appropriate environment router for the tab.
    @ViewBuilder
    func view(appRouter: AppRouter) -> some View {
        switch self {
        case .pokemon:
            PokemonHomeView()
                .environmentObject(appRouter.pokemonRouter)
        case .items:
            ItemHomeView()
                .environmentObject(appRouter.itemRouter)
        case .abilities:
            AbilityHomeView()
                .environmentObject(appRouter.abilityRouter)
        case .search:
            EmptyView()
        }
    }

    // MARK: - Search Router
    /// Returns the ``NavigationRouter`` used for searching within this tab.
    ///
    /// Defaults to the Pokémon search router when a specific router is not applicable.
    func searchRouter(appRouter: AppRouter) -> NavigationRouter {
        switch self {
        case .pokemon: return appRouter.pokemonSearchRouter
        case .items: return appRouter.itemSearchRouter
        case .abilities: return appRouter.abilitySearchRouter
        default: return appRouter.pokemonSearchRouter
        }
    }
}
