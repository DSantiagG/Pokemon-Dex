//
//  MockFactory.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import Foundation
import PokemonAPI

/// Minimal helper for decoding JSON strings into model instances for tests and previews.
///
/// `MockFactory.decode(_:)` decodes the supplied JSON string into the requested
/// `Decodable` type. It uses a custom `SelfDecodable` decoder when available,
/// otherwise it uses a `JSONDecoder` with `convertFromSnakeCase` to match API keys.
enum MockFactory {
    /// Decode `json` into `T`. On failure the helper `fatalError`s so tests/previews fail loudly.
    ///
    /// - Parameters:
    ///   - json: A string containing the JSON payload to decode.
    ///   - file: Source file for fatalError diagnostics.
    ///   - line: Source line for fatalError diagnostics.
    /// - Returns: A decoded instance of `T`.
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
