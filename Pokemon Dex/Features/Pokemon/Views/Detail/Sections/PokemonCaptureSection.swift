//
//  PokemonCaptureSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 2/12/25.
//

import SwiftUI

/// Capture-related information shown in a compact card.
///
/// - Parameters:
///   - habit: Habitat or environment string (display-only).
///   - captureRate: Capture probability metric used for display.
///   - baseExperience: Base experience reward shown for the species.
///   - growthRate: Text label describing the species' experience growth rate.
///   - color: Accent color used by the section UI.
struct PokemonCaptureSection: View {
    
    // MARK: - Parameters
    let habit: String
    let captureRate: Int
    let baseExperience: Int
    let growthRate: String
    let color: Color
    
    // MARK: - Body
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
