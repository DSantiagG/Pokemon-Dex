//
//  Image+Assets.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

/// Convenience accessors for bundled image assets used across the app.
///
/// Use these static properties to obtain `Image` instances by semantic name
/// instead of referencing asset catalog strings directly.
extension Image {
    /// Psyduck illustration used for empty/error states.
    static let pokemonPsyduck = Image("pokemon-psyduck")
    /// Pokéball icon used in UI chrome and loading indicators.
    static let pokeball = Image("pokeball-icon")
    
    /// Grouped gender-related image assets.
    enum gender {
        /// Female symbol asset.
        static let femaleSymbol = Image("female-symbol")
        /// Male symbol asset.
        static let maleSymbol = Image("male-symbol")
    }
}
