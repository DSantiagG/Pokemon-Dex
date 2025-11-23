//
//  String+Identifiable.swift
//  Pokemon Dex
//
//  Created by David Giron on 18/11/25.
//


import Foundation

public struct IdentifiedString: Identifiable, Hashable, Codable, Sendable {
    public let value: String
    public var id: String { value }

    public init(_ value: String) { self.value = value }
}

extension IdentifiedString: CustomStringConvertible {
    public var description: String { value }
}

extension IdentifiedString: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
