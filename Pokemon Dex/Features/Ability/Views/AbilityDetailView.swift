//
//  AbilityDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//

import SwiftUI
import PokemonAPI

struct AbilityDetailView: View {
    
    @StateObject private var abilityVM = AbilityViewModel(abilityService: DataProvider.shared.abilityService, pokemonService: DataProvider.shared.pokemonService)
    
    let abilityName: String
    
    var body: some View {
        ViewStateView(viewModel: abilityVM) {
            VStack {
                if abilityVM.abilityNotFound {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like this ability isn’t in our Dex yet!")
                } else if let ability = abilityVM.currentAbility {
                    ScrollView{
                        Text((ability.details.name ?? "Unknown Name").capitalized)
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(LinearGradient(colors: [.yellow, .blue], startPoint: .leading, endPoint: .trailing))
                    }
                }
            }
        }
        .task {
            await abilityVM.loadAbility(name: abilityName)
        }
    }
}

#Preview {
    AbilityDetailView(abilityName: "stench")
}
