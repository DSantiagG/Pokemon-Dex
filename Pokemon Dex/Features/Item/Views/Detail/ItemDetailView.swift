//  ItemDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//

import SwiftUI
import PokemonAPI

struct ItemDetailView: View {
    
    @StateObject private var itemVM = ItemDetailViewModel(itemService: DataProvider.shared.itemService, pokemonService: DataProvider.shared.pokemonService)
    
    let itemName: String
    var context: NavigationContext = .main
    
    var body: some View {
        ViewStateHandler(viewModel: itemVM){
            VStack {
                if case .notFound = itemVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like we couldn't find this item!")
                } else if let item = itemVM.currentItem {
                    ScrollView {
                        CustomHeader(
                            color: itemVM.displayColor,
                            imageURL: item.details.sprites?.default,
                            showSoundButton: false
                        )
                        .padding(.bottom, 60)
                        
                        VStack(spacing: 25) {
                            ItemBasicInfoSection(
                                name: itemVM.displayName,
                                category: itemVM.displayCategory,
                                cost: itemVM.displayCost,
                                description: itemVM.displayDescription,
                                color: itemVM.displayColor)
                            
                            ItemAttributesSection(
                                attributes: itemVM.displayAttributes,
                                color: itemVM.displayColor)
                            
                            EffectSection(
                                effectDescription: itemVM.displayEffect,
                                color: itemVM.displayColor)
                            
                            ItemPokemonSection(
                                pokemons: item.holdingPokemon,
                                color: itemVM.displayColor,
                                context: context)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .task {
                await itemVM.loadItem(name: itemName)
            }
        }
    }
}

#Preview {
    NavigationStack{
        ItemDetailView(itemName: "dragon-scale")
            .environmentObject(NavigationRouter())
    }
}
