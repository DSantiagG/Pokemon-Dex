//
//  AbilityList.swift
//  Pokemon Dex
//
//  Created by David Giron on 3/12/25.
//

import SwiftUI
import PokemonAPI

/// List view that renders a collection of abilities.
///
/// - Parameters:
///   - abilities: Array of abilities to display.
///   - layout: Layout used by the list (`singleColumn` or `twoColumns`).
///   - color: Accent color for list items.
///   - onItemAppear: Called when an item appears (for pagination).
///   - onItemSelected: Called when an item is selected; passes the ability name.
struct AbilityList: View {
    
    // MARK: - Properties
    let abilities: [PKMAbility]
    var layout: ListLayout = .singleColumn
    var color: Color = .red
    
    // MARK: - Callbacks
    var onItemAppear: (PKMAbility) -> Void = { _ in }
    var onItemSelected: (String?) -> Void = { _ in }
    
    // MARK: - Body
    var body: some View {
        
         CardList(
             items: abilities,
             layout: layout,
             onItemAppear: onItemAppear,
             onItemSelected: { a in onItemSelected(a.name)},
             content: { ability, _ in
                 AbilityCard(
                    ability: ability,
                    layout: layout == .twoColumns ? .vertical : .horizontal,
                    color: color)
             })
    }
}

#Preview("Two Columns") {
    let list = Array(repeating: AbilityMockFactory.mockStench(), count: 50)
    ScrollView{
        AbilityList(abilities: list,layout: .twoColumns)
            .padding(.horizontal)
    }
}

#Preview("One Column") {
    let list = Array(repeating: AbilityMockFactory.mockStench(), count: 50)
    ScrollView{
        AbilityList(abilities: list,layout: .singleColumn)
            .padding(.horizontal)
    }
}
