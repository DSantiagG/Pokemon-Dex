//
//  PokemonFormsSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 27/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonFormsSection: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    private var rows: [[PokemonFormViewModel]]
    private let hasForms: Bool
    private var isDefault: Bool
    
    let color: Color
    let context: NavigationContext
    
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
