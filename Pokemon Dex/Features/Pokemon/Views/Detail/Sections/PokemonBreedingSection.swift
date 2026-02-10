//
//  PokemonBreedingSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 2/12/25.
//

import SwiftUI

/// Breeding details section including gender ratios, egg cycles and egg groups.
///
/// - Parameters:
///   - genderRatio: Struct with `femaleRatio`/`maleRatio` as percentages (0..100) or nil when genderless.
///   - eggCycles: Hatch counter / egg cycles value.
///   - eggGroups: Array of displayable egg group names.
///   - color: Accent color for section visuals.
struct PokemonBreedingSection: View {
    
    struct GenderRatio {
        let femaleRatio: Double?
        let maleRatio: Double?
    }
    
    // MARK: - Parameters
    let genderRatio: GenderRatio
    let eggCycles: Int
    let eggGroups: [String]
    let color: Color
    
    // MARK: - View
    var body: some View {
        SectionCard(text: "Breeding", color: color) {
            HStack(alignment: .top, spacing: 0) {
                InfoColumn(title: "Gender", color: color) {
                    genderRatioInfo
                }
                
                ColumnDivider()
                
                InfoColumn(title: "Egg Cycles", color: color) {
                    Text("\(eggCycles)")
                }
                
                ColumnDivider()
                
                InfoColumn(title: "Egg Groups", color: color) {
                    VStack(spacing: 2) {
                        ForEach(eggGroups, id: \.self) { Text($0) }
                    }
                }
            }
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Subviews
    /// Computed subview showing gender or 'Genderless' message.
    var genderRatioInfo: some View {
        VStack (spacing: 2){
            if let femaleRatio = genderRatio.femaleRatio,
                let maleRatio = genderRatio.maleRatio{
                HStack{
                    Image.gender.maleSymbol
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    Text("\(maleRatio, specifier: "%.1f")%")
                }
                HStack{
                    Image.gender.femaleSymbol
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                    Text("\(femaleRatio, specifier: "%.1f")%")
                }
            } else{
                Text("Genderless")
            }
        }
    }
}

#Preview ("Gender"){
    ScrollView{
        PokemonBreedingSection(genderRatio: .init(femaleRatio: 12.5, maleRatio: 87.5), eggCycles: 20, eggGroups: ["Monster", "Plant"], color: .green)
            .padding()
    }
}

#Preview ("Genderless"){
    ScrollView{
        PokemonBreedingSection(genderRatio: .init(femaleRatio: nil, maleRatio: nil), eggCycles: 20, eggGroups: ["Monster", "Plant"], color: .green)
            .padding()
    }
}
