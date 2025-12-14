//
//  PokemonStatsSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

struct PokemonStatsSection: View{
    
    var stats: [(name: String, value: Int)]
    let color: Color
    
    var body: some View {
        SectionCard(text: "Stats", color: color) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(stats.enumerated()), id: \.offset) { _, s in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(s.name)
                                .font(.subheadline.bold())
                                .foregroundColor(color)
                                .frame(width: 87, alignment: .leading)
                            
                            Text("\(s.value)")
                                .foregroundStyle(.secondary)
                            
                            ProgressView(value: Double(s.value), total: 255)
                                .tint(color)
                        }
                    }
                }
                
                let total = stats.compactMap { $0.value }.reduce(0, +)
                
                HStack(spacing: 8) {
                    Text("Total")
                        .font(.subheadline.bold())
                        .foregroundColor(color)
                        .frame(width: 87, alignment: .leading)
                    
                    Text("\(total)")
                        .foregroundStyle(.secondary)
                    
                }
            }
        }
    }
}

#Preview{
    PokemonStatsSection(stats: [
        (name: "Hp", value: 45),
        (name: "Attack", value: 49),
        (name: "Defence", value: 49),
        (name: "Sp. Attack", value: 65),
        (name: "Sp. Defense", value: 65),
        (name: "Speed", value: 45)
    ], color: .green)
    .padding(.horizontal)
}
