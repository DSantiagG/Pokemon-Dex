//
//  StatsSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

struct StatsSection: View{
    
    var stats: [PKMPokemonStat]
    let color: Color
    
    var body: some View {
        CardView(text: "Stats", color: color) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(stats.enumerated()), id: \.offset) { _, s in
                    let name = (s.stat?.name ?? "stat")
                        .replacingOccurrences(of: "special-attack", with: "Sp. Attack")
                        .replacingOccurrences(of: "special-defense", with: "Sp. Defense")
                        .capitalized
                    
                    let value = Double(s.baseStat ?? 0)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(name)
                                .font(.subheadline.bold())
                                .foregroundColor(color)
                                .frame(width: 87, alignment: .leading)
                            
                            Text("\(Int(value))")
                                .foregroundStyle(.secondary)
                            
                            ProgressView(value: value, total: 255)
                                .tint(color)
                        }
                    }
                }
                
                let total = stats.compactMap { $0.baseStat }.reduce(0, +)
                
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
    StatsSection(stats: [
        PokemonMockFactory.mockStat(name: "hp", baseStat: 45),
        PokemonMockFactory.mockStat(name: "attack", baseStat: 49),
        PokemonMockFactory.mockStat(name: "defence", baseStat: 49),
        PokemonMockFactory.mockStat(name: "special-attack", baseStat: 65),
        PokemonMockFactory.mockStat(name: "special-defense", baseStat: 65),
        PokemonMockFactory.mockStat(name: "speed", baseStat: 45),
    ], color: .green)
    .padding(.horizontal)
}
