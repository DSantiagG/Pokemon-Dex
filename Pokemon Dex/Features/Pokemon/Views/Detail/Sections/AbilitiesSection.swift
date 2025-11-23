//
//  AbilitiesSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//
import SwiftUI
import PokemonAPI

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
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(Color(.systemBackground))
            }
        }
    }
}

#Preview{
    AbilitiesSection(abilities: [
        PokemonMockFactory.mockAbility(name: "overgrow", isHidden: false),
        PokemonMockFactory.mockAbility(name: "chlorophyll", isHidden: true),
    ], color: .green)
        .padding(.horizontal)
}
