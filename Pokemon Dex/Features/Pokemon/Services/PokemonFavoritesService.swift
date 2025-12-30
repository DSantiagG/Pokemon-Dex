//
//  PokemonFavoritesService.swift
//  Pokemon Dex
//
//  Created by David Giron on 30/12/25.
//
import Foundation

actor PokemonFavoritesService {
    
    private let key = "favorite.pokemons"
    private let storage = UserDefaults.standard
    
    private var favoritesSet: Set<String> = []
    private var favoritesOrder: [String] = []
    
    init() {
        let saved = storage.stringArray(forKey: key) ?? []
        self.favoritesOrder = saved
        self.favoritesSet = Set(saved)
    }
    
    func toggle(name: String) {
        if favoritesSet.contains(name) {
            favoritesSet.remove(name)
            favoritesOrder.removeAll { $0 == name }
        } else {
            favoritesSet.insert(name)
            favoritesOrder.append(name)
        }
        persist()
    }
    
    func getAll() -> [String] {
        favoritesOrder
    }
    
    func isFavorite(name: String) -> Bool {
        favoritesSet.contains(name)
    }
    
    private func persist() {
        storage.set(favoritesOrder, forKey: key)
    }
}
