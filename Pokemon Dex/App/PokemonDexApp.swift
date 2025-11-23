//
//  Pokemon_DexApp.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import SwiftUI

@main
struct PokemonDexApp: App {
    init() {
        configureURLCache()
    }
    
    private func configureURLCache() {
        let memoryCapacity = 100 * 1024 * 1024 // 100 MB
        let diskCapacity = 500 * 1024 * 1024   // 500 MB
        URLCache.shared = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
