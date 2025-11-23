//
//  EvolutionChainSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

struct EvolutionChainSection: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    private let rows: [[EvolutionStage]]
    private let hasEvolution: Bool
    let color: Color
    
    init(evolution: [EvolutionStage], color: Color) {
        self.color = color
        self.rows = evolution.overlappedChunks(size: 3, overlap: 1)
        hasEvolution = self.rows.flatMap { $0 }.count > 1
    }
    
    var body: some View {
        CardView(text: "Evolution Chain", color: color) {
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
                                    URLImage(urlString: evo.sprite, contentMode: .fit)
                                    Text(evo.name.capitalized)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                }
                                .onTapGesture {
                                    router.push(.pokemonDetail(name: evo.name))
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
    EvolutionChainSection(evolution: [
        PokemonMockFactory.mockStageEvolution(),
        PokemonMockFactory.mockStageEvolution(),
        PokemonMockFactory.mockStageEvolution()
    ], color: .green)
        .environmentObject(NavigationRouter())
        .padding(.horizontal)
}
