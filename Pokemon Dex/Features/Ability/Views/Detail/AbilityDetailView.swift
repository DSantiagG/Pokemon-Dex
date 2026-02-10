//
//  AbilityDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//

import SwiftUI
import PokemonAPI

/// Detail screen that shows an ability and related sections.
///
/// - Parameters:
///   - abilityName: Optional ability slug to load and display.
///   - context: Navigation context for how the view is presented.
struct AbilityDetailView: View {
    
    // MARK: - View Model
    /// View model that loads and exposes ability data.
    @StateObject private var abilityVM = AbilityDetailViewModel(abilityService: DataProvider.shared.abilityService, pokemonService: DataProvider.shared.pokemonService)
    
    // MARK: - Properties
    let abilityName: String?
    var context: NavigationContext = .main
    
    // MARK: - View
    
    var body: some View {
        ViewStateHandler(viewModel: abilityVM) {
            VStack {
                if case .notFound = abilityVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like this ability isn’t in our Dex yet!")
                } else if let ability = abilityVM.currentAbility {
                    ScrollView{
                        AbilityBasicInfoSection(
                            name: abilityVM.displayName,
                            generation: abilityVM.displayGeneration,
                            description: abilityVM.displayDescription,
                            color: abilityVM.displayColor)
                        .padding(.bottom)
                        
                        VStack (spacing: 25) {
                            
                            EffectSection(
                                effectDescription: abilityVM.displayEffect,
                                color: abilityVM.displayColor)
                            
                            AbilityPokemonSection(
                                normalPokemon: ability.normalPokemons,
                                hiddenPokemon: ability.hiddenPokemons,
                                color: abilityVM.displayColor,
                                context: context)
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
