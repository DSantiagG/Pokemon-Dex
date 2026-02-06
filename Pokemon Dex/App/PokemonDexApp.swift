//
//  Pokemon_DexApp.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import SwiftUI

/// The app's entry point that performs global configuration and hosts the root scene.
///
/// This type configures global resources (URL cache) during
/// initialization and exposes the main window group containing ``MainTabView``.
@main
struct PokemonDexApp: App {
    // MARK: - Lifecycle

    /// Creates a new application instance and performs one-time configuration.
    ///
    /// Currently this configures shared URL cache settings used by network requests.
    init() {
        URLCacheConfigurator.configure()
    }

    // MARK: - Scenes

    /// The application's scene graph.
    ///
    /// The `WindowGroup` hosts the app's root ``MainTabView``.
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
