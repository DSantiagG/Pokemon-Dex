//
//  PokemonDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonDetailView: View {
    
    @EnvironmentObject private var pokemonVM: PokemonViewModel
    
    let pokemonName: String
    
    private var pokemonColor: Color {
        (pokemonVM.currentPokemon?.pokemon.types?.first?.type?.name ?? "unknown").pokemonTypeColor
    }
    
    var body: some View {
        ViewStateView(viewModel: pokemonVM) {
            VStack {
                if pokemonVM.pokemonNotFound {
                    InfoStateView(message: "Oops!\nLooks like this Pokémon ran away before we could catch it!")
                } else if let pokemon = pokemonVM.currentPokemon {
                    ScrollView {
                        PokemonHeaderView(color: pokemonColor, imageURL: pokemon.pokemon.sprites?.other?.officialArtwork?.frontDefault)
                            .padding(.bottom, 80)
                        
                        VStack(spacing: 10) {
                            Text((pokemon.pokemon.name ?? "Unknown").capitalized)
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            
                            HStack {
                                if let types = pokemon.pokemon.types {
                                    ForEach(Array(types).enumerated(), id: \.offset) { _, type in
                                        Text((type.type?.name ?? "Unknown Type").capitalized)
                                            .font(.system(size: 19, weight: .semibold, design: .default))
                                            .foregroundStyle(Color.white)
                                            .padding(EdgeInsets(top: 3, leading: 15, bottom: 3, trailing: 15))
                                            .background((type.type?.name ?? "Unknown Type").pokemonTypeColor)
                                            .clipShape(Capsule())
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.7)
                                    }
                                }
                            }
                            
                            Text("\(pokemon.species.englishFlavorText() ?? "No description available.")")
                            
                            /*
                             HStack {
                                 ForEach(Array(pokemon.evolution).enumerated(), id: \.offset) { _ , evolution in
                                     Text("\(evolution.name.capitalized)")
                                 }
                             }
                             */
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .task {
            await pokemonVM.loadPokemon(name: pokemonName)
        }
    }
}

struct PokemonHeaderView: View {
    let color: Color
    let imageURL: String?
    
    var body: some View {
        
        GeometryReader { proxy in
            let y = proxy.frame(in: .global).minY
            color
                .opacity(0.8)
                .frame(height: max(220 + (y > 0 ? y : 0), 200))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 160,
                        bottomTrailingRadius: 160,
                        topTrailingRadius: 0
                    )
                )
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 160,
                        bottomTrailingRadius: 160,
                        topTrailingRadius: 0
                    )
                    .stroke(color, lineWidth: 1)
                )
                .shadow(color: color.opacity(0.7), radius: 20)
                .overlay(
                    URLImage(
                        urlString: imageURL,
                        contentMode: .fit
                    )
                    .frame(width: 310, height: 310)
                    .shadow(color: color, radius: 3)
                    .offset(y: 60 + (y > 0 ? y/2 : 0))
                )
                .offset(y: (y > 0) ? -y : 0)
        }
        .frame(height: 220)
    }
}

#Preview {
    PokemonDetailView(pokemonName: "bulbasaur")
        .environmentObject(PokemonViewModel())
}
