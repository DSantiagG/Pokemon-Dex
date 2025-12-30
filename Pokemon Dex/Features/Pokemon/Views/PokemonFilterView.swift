//
//  PokemonFilterView.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//

import SwiftUI

struct PokemonFilterView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let allTypes: [PokemonTypeFilterItem]
    @Binding var selectedTypes: [String]
    let applyFilters: (() -> Void)
    
    private var hasSelectedTypes: Bool {
        !selectedTypes.isEmpty
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            LazyVGrid(columns: columns) {
                ForEach(allTypes, id: \.id) { type in
                    let isActive = selectedTypes.contains(type.id)
                    Text(type.displayName)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                        .background(isActive ? type.id.pokemonTypeColor : .gray.opacity(0.4))
                        .clipShape(Capsule())
                        .scaleEffect(isActive ? 1.03 : 1.0)
                        .animation(.spring(response: 0.25, dampingFraction: 0.5), value: isActive)
                        .onTapGesture {
                            if isActive {
                                selectedTypes.removeAll { $0 == type.id }
                            } else {
                                selectedTypes.append(type.id)
                            }
                        }
                }
                .animation(.easeInOut(duration: 0.15), value: selectedTypes)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 20)
            .padding(.horizontal, 25)
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    Button("Clean All") {
                        selectedTypes.removeAll()
                        applyFilters()
                        dismiss()
                    }
                }
                 ToolbarItem(placement: .topBarTrailing) {
                     Button {
                         applyFilters()
                         dismiss()
                     } label: {
                         Text("Apply")
                             .foregroundStyle(hasSelectedTypes ? .white : .gray.opacity(0.7))
                     }
                     .disabled(!hasSelectedTypes)
                     .if(hasSelectedTypes) { buttom in
                         buttom
                             .buttonStyle(.borderedProminent)
                             .tint(.red)
                             .fontWeight(.semibold)
                     }
                 }
            }
        }
    }
}

#Preview {
    let allTypes: [PokemonTypeFilterItem] = [
        .init(id: "normal", displayName: "Normal"),
        .init(id: "fighting", displayName: "Fighting"),
        .init(id: "flying", displayName: "Flying"),
        .init(id: "poison", displayName: "Poison"),
        .init(id: "ground", displayName: "Ground"),
        .init(id: "rock", displayName: "Rock"),
        .init(id: "bug", displayName: "Bug"),
        .init(id: "ghost", displayName: "Ghost"),
        .init(id: "steel", displayName: "Steel"),
        .init(id: "fire", displayName: "Fire"),
        .init(id: "water", displayName: "Water"),
        .init(id: "grass", displayName: "Grass"),
        .init(id: "electric", displayName: "Electric"),
        .init(id: "psychic", displayName: "Psychic"),
        .init(id: "ice", displayName: "Ice"),
        .init(id: "dragon", displayName: "Dragon"),
        .init(id: "dark", displayName: "Dark"),
        .init(id: "fairy", displayName: "Fairy"),
        .init(id: "stellar", displayName: "Stellar"),
        .init(id: "unknown", displayName: "Unknown")
    ]
    
    Color.clear
        .sheet(isPresented: .constant(true)) {
            PokemonFilterView(allTypes: allTypes, selectedTypes: .constant(["water", "fire"])) {}
                .presentationDetents([.medium])
                .presentationBackground(Color(.systemBackground))
                .presentationDragIndicator(.visible)
        }
}
