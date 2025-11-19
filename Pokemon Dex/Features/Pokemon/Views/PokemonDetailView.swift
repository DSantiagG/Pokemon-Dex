//
//  PokemonDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonDetailView: View {
    
    @StateObject private var pokemonVM = PokemonViewModel(pokemonService: DataProvider.shared.pokemonService)
    @EnvironmentObject private var router: NavigationRouter
    
    let pokemonName: String
    
    private var pokemonColor: Color {
        (pokemonVM.currentPokemon?.details.types?.first?.type?.name ?? "unknown").pokemonTypeColor
    }
    
    var body: some View {
        ViewStateView(viewModel: pokemonVM) {
            VStack {
                if pokemonVM.pokemonNotFound {
                    InfoStateView(primaryText: "Oops!", secondaryText: "Looks like this Pokémon ran away before we could catch it!")
                } else if let pokemon = pokemonVM.currentPokemon {
                    ScrollView {
                        PokemonHeaderView(color: pokemonColor, imageURL: pokemon.details.sprites?.other?.officialArtwork?.frontDefault)
                            .padding(.bottom, 87)
                        
                        VStack(spacing: 25) {
                            
                            PokemonBasicInfoSection(
                                order: pokemon.details.order ?? 0,
                                name: pokemon.details.name ?? "Unknown",
                                types: pokemon.details.types,
                                flavorText: pokemon.species.englishFlavorText() ?? "No description available."
                            )
                            
                            StatsSection(stats: pokemon.details.stats ?? [], color: pokemonColor)
                            
                            AbilitiesSection(abilities: pokemon.details.abilities ?? [], color: pokemonColor)
                            
                            EvolutionChainSection(evolution: pokemon.evolution, color: pokemonColor)
                                .environmentObject(router)
                                .padding(.bottom, 60)
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

struct PokemonBasicInfoSection: View {
    let order: Int
    let name: String
    let types: [PKMPokemonType]?
    let flavorText: String
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(String(format: "#%03d", order))
                .foregroundStyle(.secondary)
                .padding(.bottom, -16)
            
            Text(name.capitalized)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            HStack {
                if let types {
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
            
            Text(flavorText)
        }
    }
}

struct StatsSection: View{
    
    var stats: [PKMPokemonStat]
    let color: Color
    
    var body: some View {
        CardView(text: "Stats", color: color) {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(stats.enumerated()), id: \.offset) { _, s in
                    let name = (s.stat?.name ?? "stat")
                        .replacingOccurrences(of: "special-attack", with: "Sp. Attack")
                        .replacingOccurrences(of: "special-defense", with: "Sp. Defense")
                        .capitalized
                    
                    let value = Double(s.baseStat ?? 0)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(name)
                                .font(.subheadline.bold())
                                .foregroundColor(color)
                                .frame(width: 87, alignment: .leading)
                            
                            Text("\(Int(value))")
                                .foregroundStyle(.secondary)
                            
                            ProgressView(value: value, total: 255)
                                .tint(color)
                        }
                    }
                }
                
                let total = stats.compactMap { $0.baseStat }.reduce(0, +)
                
                HStack(spacing: 8) {
                    Text("Total")
                        .font(.subheadline.bold())
                        .foregroundColor(color)
                        .frame(width: 87, alignment: .leading)
                    
                    Text("\(total)")
                        .foregroundStyle(.secondary)
                    
                }
            }
        }
    }
}

struct AbilitiesSection: View {
    
    @State private var selectedAbility: IdentifiedString?
    @State private var isHidden = false
    
    let abilities: [PKMPokemonAbility]
    let color: Color
    
    var body: some View {
        CardView(text: "Abilities", color: color) {
            VStack(spacing: 16) {
                ZStack(alignment: isHidden ? .trailing : .leading) {
                    
                    Color.gray.opacity(0.12)
                        .frame(height: 30)
                        .clipShape(Capsule())
                    
                    color
                        .frame(width: 175, height: 30)
                        .clipShape(Capsule())
                    
                    
                    HStack(spacing: 0) {
                        
                        Text("Normal")
                            .foregroundStyle(!isHidden ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if isHidden {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        isHidden = false
                                    }
                                }
                            }
                        
                        Text("Hidden")
                            .foregroundStyle(isHidden ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if !isHidden {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        isHidden = true
                                    }
                                }
                            }
                    }
                    .bold()
                }
                
                HStack {
                    ForEach(
                        abilities.filter { ($0.isHidden ?? false) == isHidden },
                        id: \.slot
                    ) { ability in
                        let abilityName = (ability.ability?.name ?? "Unknown").capitalized
                        
                        Text(abilityName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(color.opacity(0.9))
                            .clipShape(Capsule())
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .onTapGesture {
                                selectedAbility = IdentifiedString(abilityName)
                            }
                    }
                }
            }
            .sheet(item: $selectedAbility) { abilityName in
                AbilityDetailView(abilityName: abilityName.value)
                        .padding(.top, 20)
            }
        }
    }
}

struct EvolutionChainSection: View {
    
    @EnvironmentObject private var router: NavigationRouter
    
    private let rows: [[EvolutionStage]]
    private let hasEvolution: Bool
    let color: Color
    
    init(evolution: [EvolutionStage], color: Color) {
        self.color = color
        self.rows = EvolutionChainSection.overlappedChunks(from: evolution, chunkSize: 3)
        hasEvolution = self.rows.flatMap { $0 }.count > 1
    }
    
    var body: some View {
        CardView(text: "Evolution Chain", color: color) {
            VStack {
                if !hasEvolution {
                    Text("No evolution chain for this Pokémon. It’s already as strong as it gets!")
                        .foregroundStyle(.secondary)
                        .padding(.vertical)
                } else {
                    ForEach(Array(rows.enumerated()), id: \.offset) { (_, row) in
                        HStack (){
                            ForEach(Array(row.enumerated()), id: \.offset) { (col, evo) in
                                VStack (){
                                    URLImage(urlString: evo.sprite, contentMode: .fit)
                                    Text(evo.name.capitalized)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                }
                                .onTapGesture {
                                    router.push(.pokemonDetail(name: evo.name))
                                }
                                
                                if col < row.count - 1 {
                                    Image(systemName: "arrow.forward")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func overlappedChunks<T>(from array: [T], chunkSize: Int) -> [[T]] {
        guard chunkSize > 0, !array.isEmpty else { return [] }
        
        var result: [[T]] = []
        var start = 0
        while start < array.count {
            let end = min(start + chunkSize, array.count)
            let chunk = Array(array[start..<end])
            result.append(chunk)
            if end == array.count { break }
            start = end - 1
        }
        return result
    }
}

#Preview {
    PokemonDetailView(pokemonName: "umbreon")
        .environmentObject(NavigationRouter())
        .preferredColorScheme(.light)
}
