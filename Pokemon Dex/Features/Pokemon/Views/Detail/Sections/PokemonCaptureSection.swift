//
//  PokemonCaptureSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 2/12/25.
//

import SwiftUI

struct PokemonCaptureSection: View {
    let habit: String
    let captureRate: Int
    let baseExperience: Int
    let growthRate: String
    let color: Color
    
    var body: some View {
        SectionCard(text: "Capture", color: color) {
            VStack (spacing: 20){
                HStack(alignment: .top, spacing: 0) {
                    InfoColumn(title: "Habit", color: color) {
                        Text(habit)
                    }
                    
                    ColumnDivider()
                    
                    InfoColumn(title: "Capture Rate", color: color) {
                        Text("\(captureRate)")
                    }
                    
                    ColumnDivider()
                    
                    InfoColumn(title: "Base Experience", color: color) {
                        Text("\(baseExperience)")
                    }
                }
                InfoColumn(title: "Growth Rate", color: color) {
                    Text(growthRate)
                }
            }
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    ScrollView{
        PokemonCaptureSection(habit: "Grassland", captureRate: 45, baseExperience: 65, growthRate: "Medium Slow", color: .green)
            .padding()
    }
}
