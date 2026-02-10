//
//  PokemonFormsSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 27/11/25.
//

import SwiftUI
import PokemonAPI

/// A view that presents alternative forms of a Pokémon species in a sectioned card layout.
///
/// - Parameters:
///   - pokemonName: The currently displayed Pokémon name (used to select default form behavior).
///   - forms: Array of `PokemonFormViewModel` available for the species.
///   - color: Accent color for the section.
///   - context: Navigation context controlling navigation behavior on tap.
struct PokemonFormsSection: View {
    
    // MARK: - Environment
    /// Navigation router used to push detail screens.
    @EnvironmentObject private var router: NavigationRouter
    
    // MARK: - Properties
    private var rows: [[PokemonFormViewModel]]
    private let hasForms: Bool
    private var isDefault: Bool
    
    let color: Color
    let context: NavigationContext
    
    // MARK: - Init
    init(for pokemonName: String?, forms: [PokemonFormViewModel], color: Color, context: NavigationContext) {
        self.color = color
        hasForms = forms.count > 1
        
        guard hasForms, let pokemonName else {
            self.rows = []
            self.isDefault = true
            self.context = context
            return
        }

        let current = forms.first(where: { $0.rawName == pokemonName })

        self.isDefault = current?.isDefault ?? true
        
        let shouldShowDefaultForm = !self.isDefault
        let filtered = forms.filter { $0.isDefault == shouldShowDefaultForm }

        self.rows = filtered.overlappedChunks(size: 3, overlap: 0)
        self.context = context
    }
    
    //MARK: - View
    var body: some View {
        if hasForms {
            SectionCard(text: isDefault ? "Alternative Forms" : "Original Form", color: color) {
                VStack {
                    ForEach(Array(rows.enumerated()), id: \.offset) { (_, row) in
                        HStack (){
                            ForEach(row, id: \.id) { form in
                                Spacer()
                                formItem(form)
                                    .onTapGesture {
                                        if case .main = context, let name = form.rawName {
                                            router.push(.pokemonDetail(name: name))
                                        }
                                    }
                            }
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Subviews
    
    /// View for a single Pokémon form, showing its sprite and name.
    /// - Parameter form: View model representing a Pokémon form, including display name and sprite URL.
    /// - Returns: A view that displays the form's sprite and name, styled for presentation in the forms section.
    private func formItem(_ form: PokemonFormViewModel) -> some View {
        VStack {
            URLImage(urlString: form.spriteURL, contentMode: .fit)
                .frame(maxWidth: 120)
            AdaptiveText(text: form.displayName)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    let sprite = PokemonMockFactory.mockBulbasaur().sprites?.other?.officialArtwork?.frontDefault
    let defaultPokemon = PokemonFormViewModel(form: PokemonForm(name: "bulbasaur", sprite: sprite, isDefault: true))
    let altPokemon1 = PokemonFormViewModel(form: PokemonForm(name: "bulbasaur alt 1", sprite: sprite, isDefault: false))
    let altPokemon2 = PokemonFormViewModel(form: PokemonForm(name: "bulbasaur alt 2", sprite: sprite, isDefault: false))
    
    PokemonFormsSection(for: "bulbasaur", forms: [defaultPokemon, altPokemon1, altPokemon2], color: .green, context: .main)
        .environmentObject(NavigationRouter())
        .padding(.horizontal)
}
