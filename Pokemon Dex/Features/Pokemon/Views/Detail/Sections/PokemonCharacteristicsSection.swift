//
//  PokemonCharacteristicsSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 2/12/25.
//

import SwiftUI

struct PokemonCharacteristicsSection: View {
    
    let generation: String
    let weight: Double
    let height: Double
    let color: Color
    
    var body: some View {
        SectionCard(text: "Characteristics", color: color) {
            HStack(alignment: .top, spacing: 0) {
                InfoColumn(title: "Introduced", color: color) {
                    Text(generation)
                }
                
                ColumnDivider()
                
                InfoColumn(title: "Weight", color: color) {
                    Text("\(weight, specifier: "%.1f") kg")
                }
                
                ColumnDivider()
                
                InfoColumn(title: "Height", color: color) {
                    Text("\(height, specifier: "%.1f") m")
                }
            }
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    ScrollView{
        PokemonCharacteristicsSection(generation: "Generation II", weight: 6.3, height: 0.5, color: .green)
            .padding()
    }
}
