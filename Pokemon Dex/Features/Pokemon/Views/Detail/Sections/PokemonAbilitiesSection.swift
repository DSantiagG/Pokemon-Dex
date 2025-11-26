//
//  PokemonAbilitiesSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

struct PokemonAbilitiesSection: View {

    @State private var selectedAbility: IdentifiedString?
    
    let abilities: [PKMPokemonAbility]
    let color: Color
    
    @State private var abilityKind: AbilityKind = .normal
    
    var body: some View {
        SectionCard(text: "Abilities", color: color) {
            VStack(spacing: 16) {
                
                CustomSegmentedControl("", selection: $abilityKind, color: color, items: [
                    .init("Normal", tag: .normal),
                    .init("Hidden", tag: .hidden)
                ])
                
                HStack {
                    ForEach(
                        abilities.filter { ($0.isHidden ?? false) == (abilityKind == .hidden) }, id: \.slot) { ability in
                        let abilityName = (ability.ability?.name ?? "Unknown").capitalized
                            CustomCapsule(text: abilityName, fontSize: 16, fontWeight: .medium, color: color.opacity(0.9), verticalPadding: 6, horizontalPadding: 12)
                                .onTapGesture {
                                    selectedAbility = IdentifiedString(abilityName)
                                }
                    }
                }.animation(.easeInOut(duration: 0.25), value: abilityKind)
            }
            .sheet(item: $selectedAbility) { abilityName in
                AbilityDetailView(abilityName: abilityName.value, shouldAutoDismiss: true)
                        .padding(.top, 20)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Color(.systemBackground))
            }
        }
    }
}

#Preview{
    PokemonAbilitiesSection(abilities: [
        PokemonMockFactory.mockAbility(name: "overgrow", isHidden: false),
        PokemonMockFactory.mockAbility(name: "chlorophyll", isHidden: true),
    ], color: .green)
        .padding(.horizontal)
        .environmentObject(NavigationRouter())
}
