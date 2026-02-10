//
//  PokemonForm.swift
//  Pokemon Dex
//
//  Created by David Giron on 27/11/25.
//

import Foundation

/// Represents an alternate form of a Pokémon, including a name, sprite and whether it is the default form.
///
/// - Properties:
///   - `name`: Optional form name (e.g. "Mega Charizard X").
///   - `sprite`: Optional URL string for the form's artwork.
///   - `isDefault`: Whether this form is the Pokémon's default form.
struct PokemonForm {
    let name: String?
    let sprite: String?
    let isDefault: Bool
}
