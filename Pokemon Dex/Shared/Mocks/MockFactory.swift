//
//  MockFactory.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import Foundation
import PokemonAPI

enum MockFactory {
    static func decode<T: Decodable>(_ json: String, file: StaticString = #file, line: UInt = #line) -> T {
        let data = json.data(using: .utf8)!
        do {
            if let selfDecodableType = T.self as? any SelfDecodable.Type {
                return try selfDecodableType.decoder.decode(T.self, from: data)
            } else {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(T.self, from: data)
            }
        } catch {
            fatalError("Mock decode failed: \(error)\nJSON:\n\(json)", file: file, line: line)
        }
    }
}
