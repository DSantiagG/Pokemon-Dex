//
//  PokemonEvolutionSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

struct PokemonEvolutionSection: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    private let rows: [[EvolutionStage]]
    private let hasEvolution: Bool
    let color: Color
    let context: NavigationContext
    
    init(evolution: [EvolutionStage], color: Color, context: NavigationContext) {
        self.color = color
        self.context = context
        self.rows = evolution.overlappedChunks(size: 3, overlap: 1)
        hasEvolution = self.rows.flatMap { $0 }.count > 1
    }
    
    var body: some View {
        SectionCard(text: "Evolution Chain", color: color) {
            VStack {
                if !hasEvolution {
                    Text("No evolution chain for this Pokémon. It’s already as strong as it gets!")
                        .foregroundStyle(.secondary)
                        .padding(.vertical)
                } else {
                    ForEach(Array(rows.enumerated()), id: \.offset) { (_, row) in
                        HStack (){
                            ForEach(Array(row.enumerated()), id: \.offset) { (col, evo) in
                                let evoName = evo.name ?? "Unknown Name"
                                VStack (){
                                    URLImage(urlString: evo.sprite, contentMode: .fit)
                                    AdaptiveText(text: evoName.capitalized)
                                        .fontWeight(.medium)
                                }
                                .onTapGesture {
                                    if case .main = context {
                                        router.push(.pokemonDetail(name: evoName))
                                    }
                                }
                                
                                if col < row.count - 1 {
                                    Image(systemName: "arrow.forward")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let pokemon = PokemonMockFactory.mockBulbasaur()
    let evolution = EvolutionStage(name: pokemon.name ?? "", sprite: pokemon.sprites?.other?.officialArtwork?.frontDefault ?? "")
    let list = Array(repeating: evolution, count: 3)
    
    PokemonEvolutionSection(evolution: list, color: .green, context: .main)
        .environmentObject(NavigationRouter())
        .padding(.horizontal)
}

