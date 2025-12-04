//
//  AbilityList.swift
//  Pokemon Dex
//
//  Created by David Giron on 3/12/25.
//

import SwiftUI
import PokemonAPI

struct AbilityList: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    let abilities: [PKMAbility]
    var color: Color = .red
    
    var onItemAppear: (PKMAbility) -> Void = { _ in }
    var onItemSelected: (PKMAbility) -> Void = { _ in }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            ForEach(Array(abilities).enumerated(), id: \.offset) { _, ability in
                let abilityName = ability.name ?? "Unknown Name"
                
                AbilityCard(ability: ability, color: color)
                    .padding(3)
                    .onAppear { onItemAppear(ability) }
                    .onTapGesture {
                        onItemSelected(ability)
                        router.push(.abilityDetail(name: abilityName))
                    }
            }
        }
    }
}

private struct AbilityCard: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let ability: PKMAbility
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading){
            Text(ability.name?.formattedName() ?? "Unknown Name")
                .bold()
                .padding(.vertical, 2)
                .padding(.horizontal, 11)
                .foregroundStyle(.white)
                .background(color)
                .clipShape(Capsule())
            
            Text(ability.effectEntries?.first(where: { $0.language?.name == "en" })?.shortEffect?.cleanFlavorText() ?? "No effect available.")
        }
        .padding(EdgeInsets(top: 13, leading: 14, bottom: 13, trailing: 13))
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colorScheme == .light ? .white : .gray.opacity(0.2))
                .shadow(color: .black.opacity(0.04), radius: 2)
                .shadow(color: .black.opacity(0.05), radius: 6, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.gray.opacity(0.4), lineWidth: 0.02)
        )
    }
}

#Preview {
    let list = Array(repeating: AbilityMockFactory.mockStench(), count: 50)
    ScrollView{
        AbilityList(abilities: list, color: .red)
            .padding(.horizontal)
    }
}
