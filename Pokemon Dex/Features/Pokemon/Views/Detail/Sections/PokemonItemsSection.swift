//
//  PokemonItemsSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import SwiftUI
import PokemonAPI

struct PokemonItemsSection: View {
    
    @EnvironmentObject private var router: NavigationRouter
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: String?
    
    let items: [PKMItem]
    let color: Color
    
    let context: NavigationContext
    
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
