//
//  AbilityDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//

import SwiftUI
import PokemonAPI

struct AbilityDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var abilityVM = AbilityDetailViewModel(abilityService: DataProvider.shared.abilityService, pokemonService: DataProvider.shared.pokemonService)
    
    let abilityName: String
    var shouldAutoDismiss: Bool = false
    var abilityColor: Color = .red
    
    var body: some View {
        ViewStateHandler(viewModel: abilityVM) {
            VStack {
                if case .notFound = abilityVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like this ability isn’t in our Dex yet!")
                } else if let ability = abilityVM.currentAbility {
                    ScrollView{
                        VStack (spacing: 25) {
                            AbilityBasicInfoSection(
                                name: (ability.details.name ?? "Unknown Name").capitalized,
                                generation: (ability.details.generation?.name ?? "Unknown Generation").formattedGeneration(),
                                description: ability.details.flavorTextEntries?.englishFlavorText() ?? "No description available.",
                                color: abilityColor
                            )
                            .padding(.bottom)
                            
                            AbilityEffectSection(effectDescription: ability.details.effectEntries?.first(where: { $0.language?.name == "en" })?.effect?.cleanFlavorText() ?? "No effect available.", color: abilityColor)
                            
                            AbilityPokemonSection(normalPokemon: ability.normalPokemons, hiddenPokemon: ability.hiddenPokemons, color: abilityColor) {
                                if shouldAutoDismiss {
                                    dismiss()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .task {
            await abilityVM.loadAbility(name: abilityName)
        }
    }
}

private struct AbilityBasicInfoSection: View {
    
    var name: String
    var generation: String
    var description: String
    var color: Color
    
    var body: some View{
        VStack (spacing: 16){
            Text(name.formattedName())
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            CustomCapsule(text: generation, fontWeight: .semibold, color: color, horizontalPadding: 15)
            
            Text(description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private struct AbilityEffectSection: View {
    var effectDescription: String
    var color: Color
    
    var body: some View {
        SectionCard(text: "Effect", color: color) {
            Text(effectDescription)
        }
    }
}

private struct AbilityPokemonSection: View {
    
    @State private var pokemonKind: PokemonKind = .normal
    
    var normalPokemon: [PKMPokemon]
    var hiddenPokemon: [PKMPokemon]
    var color: Color
    var onSelectPokemon: () -> Void
    
    var body: some View {
        SectionCard(text: "Potential Pokémon", color: color) {
            CustomSegmentedControl(selection: $pokemonKind, color: color, items: [
                .init("Normal", tag: .normal),
                .init("Hidden", tag: .hidden)
            ])
            
            PokemonListView(pokemons: (pokemonKind == .normal) ? normalPokemon : hiddenPokemon, layout: .singleColumn, onItemSelected: {
                onSelectPokemon()
            })
        }
    }
}

#Preview {
    NavigationStack{
        AbilityDetailView(abilityName: "stench")
            .environmentObject(NavigationRouter())
    }
}
