//
//  PokemonFormViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//

import Foundation

struct PokemonFormViewModel: Identifiable {
    private let form: PokemonForm
    
    init(form: PokemonForm) {
        self.form = form
    }
    
    var id: String {
        form.name ?? UUID().uuidString
    }
    
    var rawName: String? {
        form.name
    }
    
    var displayName: String {
        form.name?.formattedName() ?? "Unknown Name"
    }
    
    var spriteURL: String? {
        form.sprite
    }
    
    var isDefault: Bool {
        form.isDefault
    }
}
