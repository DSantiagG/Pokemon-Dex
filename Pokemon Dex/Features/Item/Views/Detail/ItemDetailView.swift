//  ItemDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//

import SwiftUI
import PokemonAPI

/// Detail screen presenting a single item's information, attributes and holding Pokémon.
///
/// - Parameters:
///   - itemName: Optional slug of the item to display (e.g. "master-ball").
///   - context: NavigationContext controlling presentation behavior for nested navigation.
///
/// Behavior:
/// - Loads item data via ``ItemDetailViewModel`` and renders ``InfoStateView`` for error/empty states.
struct ItemDetailView: View {
    
    // MARK: - ViewModel
    /// ViewModel responsible for loading item details and exposing display properties.
    @StateObject private var itemVM = ItemDetailViewModel(itemService: DataProvider.shared.itemService, pokemonService: DataProvider.shared.pokemonService)
    
    // MARK: - Parameters
    
    let itemName: String?
    var context: NavigationContext = .main
    
    // MARK: - View
    
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
