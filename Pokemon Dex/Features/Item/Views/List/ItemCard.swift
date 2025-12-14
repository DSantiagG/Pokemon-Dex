//
//  ItemCard.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import SwiftUI
import PokemonAPI

struct ItemCard: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var item: PKMItem
    var layout: CardOrientation = .vertical
    
    private var itemColor: Color {
        item.category?.name?.categoryColor ?? .gray
    }
    
    private var displayName: String {
        item.name?.formattedName() ?? "Unknown Name"
    }
    
    private var displayCategory: String {
        item.category?.name?.formattedName() ?? "Unknown Category"
    }
    
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
