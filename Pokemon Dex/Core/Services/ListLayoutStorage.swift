//
//  ListLayoutStorage.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//


import Foundation

protocol ListLayoutStorageProtocol {
    func getLayout(for key: ListLayoutKey) -> ListLayout
    func setLayout(_ layout: ListLayout, for key: ListLayoutKey)
}

final class ListLayoutStorage: ListLayoutStorageProtocol {
    
    private let defaults = UserDefaults.standard
    
    func getLayout(for key: ListLayoutKey) -> ListLayout {
        guard
            let rawValue = defaults.string(forKey: key.rawValue),
            let layout = ListLayout(rawValue: rawValue)
        else {
            return key.defaultLayout
        }
        return layout
    }
    
    func setLayout(_ layout: ListLayout, for key: ListLayoutKey) {
        defaults.set(layout.rawValue, forKey: key.rawValue)
    }
}
