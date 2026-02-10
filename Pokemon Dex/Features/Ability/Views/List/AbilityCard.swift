//
//  AbilityCard.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//
import SwiftUI
import PokemonAPI

/// Compact card view representing an ability for lists.
///
/// - Parameters:
///   - ability: The ability model to display.
///   - layout: Orientation of the card layout.
///   - color: Accent color for the card.
struct AbilityCard: View {
    
    // MARK: - Environment
    /// Current color scheme (light/dark).
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Properties
    let ability: PKMAbility
    var layout: CardOrientation = .horizontal
    var color: Color = .red
    
    // MARK: - Computed
    /// Formatted ability name with fallback.
    private var displayName: String {
        ability.name?.formattedName() ?? "Unknown Name"
    }
    
    /// Formatted generation string with fallback.
    private var displayGeneration: String {
        ability.generation?.name?.formattedGeneration() ?? "Unknown Generation"
    }
    
    /// Short effect text for the ability, with fallback if not available.
    private var displayShortEffect: String {
        ability.effectEntries?.first(where: { $0.language?.name == "en" })?.shortEffect?.cleanFlavorText() ?? "No effect available"
    }
    
    // MARK: - Body
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
    
    // MARK: - Subviews
    /// Capsule showing the ability name.
    private var title: some View {
        CustomCapsule(
            text: displayName,
            fontWeight: .bold,
            color: color.opacity(0.9),
            verticalPadding: 2,
            horizontalPadding: 11,
            isMultiline: false)
    }
    
    /// Generation label styled with the accent color.
    private var generation: some View{
        Text(displayGeneration)
            .foregroundStyle(color)
            .shadow(color: color, radius: 4)
    }
    
    /// Short effect description.
    private var shortEffect: some View {
        Text(displayShortEffect)
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
