//
//  URLCacheConfigurator.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/02/26.
//

import Foundation

// MARK: - URL Cache Configurator

/// Small utility to configure the shared `URLCache` used by network requests.
///
/// Call `configure()` early in the app lifecycle to set sensible memory and disk
/// capacities for URL caching.
enum URLCacheConfigurator {
    /// Configure the global `URLCache.shared` instance with predetermined
    /// memory and disk capacities.
    ///
    /// The current implementation sets:
    /// - memoryCapacity: 100 MB
    /// - diskCapacity: 500 MB
    static func configure() {
        let memoryCapacity = 100 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        URLCache.shared = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity
        )
    }
}
