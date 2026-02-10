//
//  PokemonItemsSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import SwiftUI
import PokemonAPI

/// A view that presents a section of items that a Pokémon can hold.
///
/// - Parameters:
///   - items: Items that this Pokémon can hold.
///   - color: Accent color for the section.
///   - context: Navigation context controlling push vs sheet behavior when selecting items.
struct PokemonItemsSection: View {
    
    // MARK: - Environment
    /// Used to navigate to item detail.
    @EnvironmentObject private var router: NavigationRouter
    /// Dismiss action for sheet contexts.
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    /// Currently selected item name for sheet presentation.
    @State private var selectedItem: String?
    
    // MARK: - Parameters
    let items: [PKMItem]
    let color: Color
    let context: NavigationContext
    
    // MARK: - View
    var body: some View {
        if !items.isEmpty {
            SectionCard(text: "Items", color: color) {
                ItemList(
                    items: items,
                    layout: .singleColumn,
                    onItemSelected: { itemName in
                        switch context {
                        case .sheet(.item):
                            dismiss()
                            router.push(.itemDetail(name: itemName))
                        case .main, .sheet(.ability), .sheet(.pokemon):
                            selectedItem = itemName
                        }
                    })
            }
            .sheet(item: $selectedItem) { itemName in
                ItemDetailView(
                    itemName: itemName,
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
        PokemonItemsSection(
            items: [ ItemMockFactory.mockMasterBall() ],
            color: .green,
            context: .main)
        .padding(.horizontal)
        .environmentObject(NavigationRouter())
    }
}
