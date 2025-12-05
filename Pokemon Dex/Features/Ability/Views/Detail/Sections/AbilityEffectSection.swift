//
//  AbilityEffectSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 4/12/25.
//
import SwiftUI

struct AbilityEffectSection: View {
    var effectDescription: String
    var color: Color
    
    var body: some View {
        SectionCard(text: "Effect", color: color) {
            Text(effectDescription)
        }
    }
}

#Preview {
    ScrollView{
        AbilityEffectSection(effectDescription: "This Pokémon's damaging moves have a 10% chance to make the target flinch with each hit if they do not already cause flinching as a secondary effect. This ability does not stack with a held item. Overworld: The wild encounter rate is halved while this Pokémon is first in the party.", color: .green)
            .padding(.horizontal)
    }
}
