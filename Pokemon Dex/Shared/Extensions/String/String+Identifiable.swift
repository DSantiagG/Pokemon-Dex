//
//  String+Identifiable.swift
//  Pokemon Dex
//
//  Created by David Giron on 18/11/25.
//

/// Make `String` conform to `Identifiable` using the string value as its `id`.
///
/// This retroactive conformance allows `String` to be used directly in SwiftUI
/// collections that require `Identifiable` elements (e.g. `ForEach`).
extension String: @retroactive Identifiable {
    public var id: String { self }
}
