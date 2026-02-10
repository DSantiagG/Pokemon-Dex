//
//  CardList.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//


import SwiftUI

/// A reusable container that renders an array of items as a scrollable list or grid.
///  
/// ``CardList`` adapts its layout between a two-column grid and a single-column
/// vertical list based on the provided `layout` parameter. The view delegates
/// rendering of each item to the caller-supplied `content` closure so it can be
/// used with any model type `T`.
///  
/// - Parameters:
///    - items: The array of items to display.
///    - layout: The presentation layout (twoColumns or singleColumn).
///    - onItemAppear: Callback when an item appears (useful for pagination).
///    - onItemSelected: Callback when an item is tapped/selected.
///    - content: Closure that generates the view for each item, receiving the current item
///    and the active `ListLayout` for adaptive presentation.
///  
/// Example:
/// ```swift
/// CardList(items: pokemons, layout: .twoColumns) { pokemon, layout in
///     PokemonCard(pokemon: pokemon, layout: layout)
/// }
/// ```
struct CardList<T, Content: View>: View {
    
    // MARK: - Properties
    
    let items: [T]
    var layout: ListLayout = .twoColumns
    
    var onItemAppear: (T) -> Void = { _ in }
    var onItemSelected: (T) -> Void = { _ in }
    
    let content: (T, ListLayout) -> Content
    
    // Two flexible columns used for the grid layout.
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - View
    
    /// The main view body. Switches between `LazyVGrid` and `LazyVStack`
    /// depending on `layout`, and delegates item rendering to `content`.
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
    
    // MARK: - Helpers
    
    /// Internal view that iterates the `items` array and wraps each generated
    /// content view with common modifiers (padding, appearance callbacks,
    /// and tap handling).
    ///
    /// Note: `ForEach` uses the enumerated offset as the identifier. This
    /// intentionally avoids requiring `T` to conform to `Identifiable`; ensure
    /// the order of `items` is stable for predictable updates.
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
