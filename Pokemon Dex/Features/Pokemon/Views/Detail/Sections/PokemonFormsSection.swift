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
    
    private var rows: [[PokemonForm]]
    private let hasForms: Bool
    private var isDefault: Bool
    
    let color: Color
    
    init(for pokemonName: String, forms: [PokemonForm], color: Color) {
        self.color = color
        hasForms = forms.count > 1
        
        guard hasForms else {
            self.rows = []
            self.isDefault = true
            return
        }

        let current = forms.first(where: { $0.name == pokemonName })

        self.isDefault = current?.isDefault ?? true
        
        let shouldShowDefaultForm = !self.isDefault
        let filtered = forms.filter { $0.isDefault == shouldShowDefaultForm }

        self.rows = filtered.overlappedChunks(size: 3, overlap: 0)
    }
    
    var body: some View {
        if hasForms {
            SectionCard(text: isDefault ? "Alternative Forms" : "Original Form", color: color) {
                VStack {
                    ForEach(Array(rows.enumerated()), id: \.offset) { (_, row) in
                        HStack (){
                            ForEach(Array(row.enumerated()), id: \.offset) { (_, form) in
                                let formName = form.name ?? "Unknown Name"
                                    formItem(form)
                                    .onTapGesture {
                                        router.push(.pokemonDetail(name: formName))
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    private func formItem(_ form: PokemonForm) -> some View {
        VStack {
            URLImage(urlString: form.sprite, contentMode: .fit)
                .frame(maxWidth: 120)
            AdaptiveText(text: form.name?.formattedName() ?? "Unknown Name")
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    let sprite = PokemonMockFactory.mockBulbasaur().sprites?.other?.officialArtwork?.frontDefault
    let defaultPokemon = PokemonForm(name: "bulbasaur", sprite: sprite, isDefault: true)
    let altPokemon1 = PokemonForm(name: "bulbasaur alternative 1", sprite: sprite, isDefault: false)
    let altPokemon2 = PokemonForm(name: "bulbasaur alternative 2", sprite: sprite, isDefault: false)
    
    PokemonFormsSection(for: "bulbasaur", forms: [defaultPokemon, altPokemon1, altPokemon2], color: .green)
        .environmentObject(NavigationRouter())
        .padding(.horizontal)
}
