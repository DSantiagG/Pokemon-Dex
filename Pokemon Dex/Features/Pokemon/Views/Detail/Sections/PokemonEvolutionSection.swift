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
    
    private let rows: [[EvolutionStageViewModel]]
    private let hasEvolution: Bool
    let color: Color
    let context: NavigationContext
    
    init(evolution: [EvolutionStageViewModel], color: Color, context: NavigationContext) {
        self.color = color
        self.context = context
        self.rows = evolution.overlappedChunks(size: 3, overlap: 1)
        self.hasEvolution = self.rows.flatMap { $0 }.count > 1
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
                                VStack (){
                                    URLImage(urlString: evo.spriteURL, contentMode: .fit)
                                    AdaptiveText(text: evo.displayName)
                                        .fontWeight(.medium)
                                }
                                .onTapGesture {
                                    if case .main = context, let name = evo.rawName {
                                        router.push(.pokemonDetail(name: name))
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
    let evolution = EvolutionStage(name: pokemon.name, sprite: pokemon.sprites?.other?.officialArtwork?.frontDefault)
    let list = Array(repeating: EvolutionStageViewModel(stage: evolution), count: 3)
    
    PokemonEvolutionSection(evolution: list, color: .green, context: .main)
        .environmentObject(NavigationRouter())
        .padding(.horizontal)
}

