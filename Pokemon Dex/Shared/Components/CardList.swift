//
//  CardList.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//


import SwiftUI

struct CardList<T, Content: View>: View {
    
    let items: [T]
    var layout: ListLayout = .twoColumns
    
    var onItemAppear: (T) -> Void = { _ in }
    var onItemSelected: (T) -> Void = { _ in }
    
    let content: (T, ListLayout) -> Content
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        switch layout {
        case .twoColumns:
            LazyVGrid(columns: columns) {
                listView
            }
        case .singleColumn:
            LazyVStack(alignment: .leading, spacing: 8) {
                listView
            }
        }
    }
    
    private var listView: some View {
        ForEach(Array(items.enumerated()), id: \.offset) { _, item in
            content(item, layout)
                .padding(layout == .twoColumns ? 3 : 0)
                .onAppear { onItemAppear(item) }
                .onTapGesture { onItemSelected(item) }
        }
    }
}

#Preview ("Single Column"){
    let array = Array(1...30)
    ScrollView{
        CardList(items: array, layout: .singleColumn) { varNumber, _ in
            Text("\(varNumber)")
        }
    }
}

#Preview ("Two Columns"){
    let array = Array(1...30)
    ScrollView{
        CardList(items: array, layout: .twoColumns) { varNumber, _ in
            Text("\(varNumber)")
        }
    }
}
