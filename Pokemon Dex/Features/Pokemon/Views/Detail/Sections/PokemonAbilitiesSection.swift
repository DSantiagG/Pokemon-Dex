//
//  PokemonAbilitiesSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

struct PokemonAbilitiesSection: View {
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss

    @State private var selectedAbility: IdentifiedString?
    @State private var abilityKind: AbilityKind = .normal
    
    let normalAbilities: [PKMAbility]
    let hiddenAbilities: [PKMAbility]
    let color: Color
    
    let context: NavigationContext
    
    var body: some View {
        SectionCard(text: "Abilities", color: color) {
            VStack(spacing: 16) {
                
                CustomSegmentedControl("", selection: $abilityKind, color: color, items: [
                    .init("Normal", tag: .normal),
                    .init("Hidden", tag: .hidden)
                ])
                
                AbilityList(
                    abilities: (abilityKind == .normal) ? normalAbilities : hiddenAbilities, color: color,
                    onItemSelected: { abilityName in
                        switch context {
                        case .sheet:
                            dismiss()
                            router.push(.abilityDetail(name: abilityName))
                        case .main:
                            selectedAbility = IdentifiedString(abilityName)
                        }
                })
            }
            .sheet(item: $selectedAbility) { abilityName in
                AbilityDetailView(abilityName: abilityName.value, context: .sheet)
                        .presentationDetents([.medium, .large])
                        .presentationBackground(Color(.systemBackground))
            }
        }
    }
}

#Preview {
    NavigationStack{
        PokemonAbilitiesSection(
            normalAbilities: [ AbilityMockFactory.mockStench()],
            hiddenAbilities: [ AbilityMockFactory.mockStench()],
            color: .green,
            context: .main)
            .padding(.horizontal)
            .environmentObject(NavigationRouter())
    }
}

