//
//  ItemList.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import SwiftUI
import PokemonAPI

struct ItemList: View {
    
    let items: [PKMItem]
    var layout: ListLayout = .twoColumns
    
    var onItemAppear: (PKMItem) -> Void = { _ in }
    var onItemSelected: (String) -> Void = { _ in }
    
    var body: some View {
        CardList(
            items: items,
            layout: layout,
            onItemAppear: onItemAppear,
            onItemSelected: { i in onItemSelected(i.name ?? "Unknown Name")},
            content: { item, layout in
                ItemCard(
                    item: item,
                    layout: layout == .twoColumns ? .vertical : .horizontal
                )
                .frame(height: layout == .singleColumn ? 90 : 220)
            })
    }
}

#Preview("Two Columns") {
    let list = Array(repeating: ItemMockFactory.mockMasterBall(), count: 30)
    ScrollView{
        ItemList(items: list,layout: .twoColumns)
            .padding(.horizontal)
    }
}

#Preview("One Column") {
    let list = Array(repeating: ItemMockFactory.mockMasterBall(), count: 30)
    ScrollView{
        ItemList(items: list,layout: .singleColumn)
            .padding(.horizontal)
    }
}
