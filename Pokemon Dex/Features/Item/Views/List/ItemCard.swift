//
//  ItemCard.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import SwiftUI
import PokemonAPI

/// A compact card view presenting an item's artwork, title and category.
///
/// - Parameters:
///   - item: The `PKMItem` model to display.
///   - layout: Orientation used by `CardContainer` to switch between vertical and horizontal layouts.
///
/// Computed properties:
/// - `itemColor`: Accent color derived from the item's category.
/// - `displayName`: Formatted item name for display.
/// - `displayCategory`: Formatted category name for display.
struct ItemCard: View {
    
    // MARK: - Environment
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Parameters
    
    var item: PKMItem
    var layout: CardOrientation = .vertical
    
    // MARK: - Computed
    
    private var itemColor: Color {
        item.category?.name?.categoryColor ?? .gray
    }
    
    private var displayName: String {
        item.name?.formattedName() ?? "Unknown Name"
    }
    
    private var displayCategory: String {
        item.category?.name?.formattedName() ?? "Unknown Category"
    }
    
    // MARK: - Body
    
    var body: some View {
        
        CardContainer(color: itemColor, layout: layout) {
            VStack(alignment: .center, spacing: 8) {
                image
                title
                category
            }
        } contentHorizontal: {
            HStack(spacing: 12) {
                image
                VStack(alignment: .leading, spacing: 4) {
                    title
                    category
                }
                Spacer()
                VStack{
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    private var image: some View {
        URLImage(
            urlString: item.sprites?.default,
            cornerRadius: 5,
            contentMode: .fit
        )
        .shadow(color: itemColor, radius: 6)
    }
    
    private var title: some View {
        AdaptiveText(text: displayName, isMultiline: false)
            .bold()
    }
    
    private var category: some View {
        CustomCapsule(text: displayCategory, color: itemColor)
    }
}

#Preview ("Vertical") {
    let item = ItemMockFactory.mockMasterBall()
    ItemCard(item: item, layout: .vertical)
        .padding()
}

#Preview ("Horizontal") {
    let item = ItemMockFactory.mockMasterBall()
    ItemCard(item: item, layout: .horizontal)
        .frame(height: 90)
        .padding()
}
