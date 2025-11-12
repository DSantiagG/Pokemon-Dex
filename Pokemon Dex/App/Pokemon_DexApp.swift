//
//  Pokemon_DexApp.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import SwiftUI

@main
struct Pokemon_DexApp: App {
    
    init() {
        let memoryCapacity = 100 * 1024 * 1024 // 100 MB
        let diskCapacity = 500 * 1024 * 1024   // 500 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
        URLCache.shared = cache
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
