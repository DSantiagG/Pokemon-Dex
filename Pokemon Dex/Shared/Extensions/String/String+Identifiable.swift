//
//  String+Identifiable.swift
//  Pokemon Dex
//
//  Created by David Giron on 18/11/25.
//

extension String: @retroactive Identifiable {
    public var id: String { self }
}
