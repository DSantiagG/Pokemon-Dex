//
//  PokemonAbilitiesSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

/// Section displaying a Pokémon's abilities with segmented control for normal/hidden.
///
/// - Parameters:
///   - normalAbilities: Array of `PKMAbility` shown when `abilityKind == .normal`.
///   - hiddenAbilities: Array of `PKMAbility` shown when `abilityKind == .hidden`.
///   - color: Accent color used for capsule/section styling.
///   - context: NavigationContext controlling push vs sheet presentation when selecting an ability.
struct PokemonAbilitiesSection: View {
    
    // MARK: - Environment
    ///Used to navigate to ability detail.
    @EnvironmentObject private var router: NavigationRouter
    /// Dismiss action for sheet contexts.
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    /// Currently selected ability name for presenting details.
    @State private var selectedAbility: String?
    /// Currently selected ability kind (normal/hidden).
    @State private var abilityKind: AbilityKind = .normal
    
    // MARK: - Parameters
    let normalAbilities: [PKMAbility]
    let hiddenAbilities: [PKMAbility]
    let color: Color
    let context: NavigationContext

    // MARK: - Body
    var body: some View {
        SectionCard(text: "Abilities", color: color) {
            VStack(spacing: 16) {
                
                CustomSegmentedControl(selection: $abilityKind, color: color, items: [
                    .init("Normal", tag: .normal),
                    .init("Hidden", tag: .hidden)
                ])
                
                AbilityList(
                    abilities: (abilityKind == .normal) ? normalAbilities : hiddenAbilities,
                    color: color,
                    onItemSelected: { abilityName in
                        switch context {
                        case .sheet(.ability):
                            dismiss()
                            router.push(.abilityDetail(name: abilityName))
                            
                        case .main, .sheet(.item), .sheet(.pokemon):
                            selectedAbility = abilityName
                        }
                    })
            }
            .sheet(item: $selectedAbility) { abilityName in
                AbilityDetailView(
                    abilityName: abilityName,
                    context: {
                        if case .main = context { return .sheet(.pokemon) }
                        return context
                    }()
                )
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
