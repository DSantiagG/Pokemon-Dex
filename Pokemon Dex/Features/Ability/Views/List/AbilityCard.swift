//
//  AbilityCard.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//
import SwiftUI
import PokemonAPI

struct AbilityCard: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let ability: PKMAbility
    var layout: CardOrientation = .horizontal
    var color: Color = .red
    
    var body: some View {
        CardContainer(color: color, layout: layout) {
            VStack{
                title
                generation
            }
        } contentHorizontal: {
            VStack(alignment: .leading, spacing: 8) {
                title
                shortEffect
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var title: some View {
        CustomCapsule(
            text: ability.name?.formattedName() ?? "Unknown Name",
            fontWeight: .bold,
            color: color.opacity(0.9),
            verticalPadding: 2,
            horizontalPadding: 11,
            isMultiline: false)
    }
    
    private var generation: some View{
        Text(ability.generation?.name?.formattedGeneration() ?? "Unknown Generation")
            .foregroundStyle(color)
            .shadow(color: color, radius: 4)
    }
    
    private var shortEffect: some View {
        Text(ability.effectEntries?.first(where: { $0.language?.name == "en" })?.shortEffect?.cleanFlavorText() ?? "No effect available.")
    }
}

#Preview ("Vertical") {
    AbilityCard(ability: AbilityMockFactory.mockStench(), layout: .vertical)
        .padding()
}

#Preview ("Horizontal") {
    AbilityCard(ability: AbilityMockFactory.mockStench(), layout: .horizontal)
        .padding()
}
