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
    @State private var abilityKind: AbilityKind = .normal
    
    let normalAbilities: [PKMAbility]
    let hiddenAbilities: [PKMAbility]
    let color: Color
    var onSelectAbility: () -> Void
    
    var body: some View {
        SectionCard(text: "Abilities", color: color) {
            VStack(spacing: 16) {
                
                CustomSegmentedControl("", selection: $abilityKind, color: color, items: [
                    .init("Normal", tag: .normal),
                    .init("Hidden", tag: .hidden)
                ])
                
                AbilityList(abilities: (abilityKind == .normal) ? normalAbilities : hiddenAbilities, color: color, onItemSelected: { ability in
                    selectedAbility = IdentifiedString(ability.name ?? "Unknown name")
                    onSelectAbility()
                })
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
    PokemonAbilitiesSection(
        normalAbilities: [
            AbilityMockFactory.mockStench(),
            AbilityMockFactory.mockStench()
        ],
        hiddenAbilities: [
            AbilityMockFactory.mockStench()
        ],
        color: .green){
            
        }
        .padding(.horizontal)
        .environmentObject(NavigationRouter())
}
