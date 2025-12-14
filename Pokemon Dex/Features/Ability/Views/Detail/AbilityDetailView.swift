//
//  AbilityDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//

import SwiftUI
import PokemonAPI

struct AbilityDetailView: View {
    
    @StateObject private var abilityVM = AbilityDetailViewModel(abilityService: DataProvider.shared.abilityService, pokemonService: DataProvider.shared.pokemonService)
    
    private var abilityColor: Color { abilityVM.currentAbility?.normalPokemons.first?.types?.first?.color ?? .gray }
    
    let abilityName: String
    var context: NavigationContext = .main
    
    var body: some View {
        ViewStateHandler(viewModel: abilityVM) {
            VStack {
                if case .notFound = abilityVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like this ability isn’t in our Dex yet!")
                } else if let ability = abilityVM.currentAbility {
                    ScrollView{
                        AbilityBasicInfoSection(
                            name: (ability.details.name ?? "Unknown Name").capitalized,
                            generation: (ability.details.generation?.name ?? "Unknown Generation").formattedGeneration(),
                            description: ability.details.flavorTextEntries?.englishFlavorText() ?? "No description available.",
                            color: abilityColor
                        )
                        .padding(.bottom)
                        
                        VStack (spacing: 25) {
                            
                            AbilityEffectSection(effectDescription: ability.details.effectEntries?.first(where: { $0.language?.name == "en" })?.effect?.cleanFlavorText() ?? "No effect available.", color: abilityColor)
                            
                            AbilityPokemonSection(normalPokemon: ability.normalPokemons, hiddenPokemon: ability.hiddenPokemons, color: abilityColor, context: context)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
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
    NavigationStack{
        AbilityDetailView(abilityName: "stench")
            .environmentObject(NavigationRouter())
    }
}
