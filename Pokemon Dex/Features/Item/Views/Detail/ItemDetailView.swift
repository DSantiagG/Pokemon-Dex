//
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
    
    private var itemColor: Color {
        itemVM.currentItem?.details.category?.name?.categoryColor ?? .gray
    }
    
    var body: some View {
        ViewStateHandler(viewModel: itemVM){
            VStack {
                if case .notFound = itemVM.state {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like we couldn't find this item!")
                } else if let item = itemVM.currentItem {
                    ScrollView {
                        CustomHeader(
                            color: itemColor,
                            imageURL: item.details.sprites?.default,
                            showSoundButton: false
                        )
                        .padding(.bottom, 87)
                        
                        VStack(spacing: 25) {
                            
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
        ItemDetailView(itemName: "master-ball")
            .environmentObject(NavigationRouter())
    }
}
