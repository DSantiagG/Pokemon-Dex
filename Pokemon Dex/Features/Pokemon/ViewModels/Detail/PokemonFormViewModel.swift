//
//  PokemonFormViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//

import Foundation

/// Presentation view model for a single Pokémon form used in detail screens.
struct PokemonFormViewModel: Identifiable {
    /// Backing `PokemonForm` model used to compute presentation properties.
    /// Kept private to encapsulate model details and prevent external mutation.
    private let form: PokemonForm
    
    
    /// Initialize with a `PokemonForm` model.
    /// - Parameter form: The underlying model containing raw form data.
    init(form: PokemonForm) {
        self.form = form
    }
    
    /// Stable identifier for SwiftUI lists; falls back to a UUID when the name is missing.
    var id: String {
        form.name ?? UUID().uuidString
    }
    
    /// Raw name slug from the underlying model.
    var rawName: String? {
        form.name
    }
    
    /// Formatted human-friendly name for display.
    var displayName: String {
        form.name?.formattedName() ?? "Unknown Name"
    }
    
    /// Optional sprite URL for the form.
    var spriteURL: String? {
        form.sprite
    }
    
    /// Whether this form is the default one for the Pokémon.
    var isDefault: Bool {
        form.isDefault
    }
}
