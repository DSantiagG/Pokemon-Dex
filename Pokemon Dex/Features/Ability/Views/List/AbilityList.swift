//
//  AbilityList.swift
//  Pokemon Dex
//
//  Created by David Giron on 3/12/25.
//

import SwiftUI
import PokemonAPI

struct AbilityList: View {
    
    let abilities: [PKMAbility]
    var layout: ListLayout = .singleColumn
    var color: Color = .red
    
    var onItemAppear: (PKMAbility) -> Void = { _ in }
    var onItemSelected: (String) -> Void = { _ in }
    
    var body: some View {
        
         CardList(
             items: abilities,
             layout: layout,
             onItemAppear: onItemAppear,
             onItemSelected: { a in onItemSelected(a.name ?? "Unknown Name")},
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
