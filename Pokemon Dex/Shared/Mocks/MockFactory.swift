//
//  MockFactory.swift
//  Pokemon Dex
//
//  Created by David Giron on 24/11/25.
//
import Foundation
import PokemonAPI

class MockFactory {

    static func loadPokemon(from filename: String) -> PKMPokemon {
        loadJSON(filename)
    }

    private static func loadJSON<T: Decodable>(_ name: String) -> T {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else {
            fatalError("Missing file: \(name).json")
        }

        do {
            if let selfDecodableType = T.self as? any SelfDecodable.Type {
                return try selfDecodableType.decoder.decode(T.self, from: data)
            } else {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            }
        } catch {
            fatalError("MockFactory failed to decode \(name).json: \(error)")
        }
    }
}
