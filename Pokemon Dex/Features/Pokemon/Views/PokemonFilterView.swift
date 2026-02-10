//
//  PokemonFilterView.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//

import SwiftUI

/// A filter sheet that lets users pick Pokémon types to filter the main list.
///
/// - Parameters:
///   - allTypes: An array of ``PokemonTypeFilterItem`` representing available types.
///   - selectedTypes: Binding to the currently selected type ids.
///   - applyFilters: Closure invoked when user taps "Apply" to confirm selection.
struct PokemonFilterView: View {
    
    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Inputs
    let allTypes: [PokemonTypeFilterItem]
    @Binding var selectedTypes: [String]
    let applyFilters: (() -> Void)
    
    // MARK: - Layout
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - View
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
                            // Toggle selection: remove if active, append otherwise.
                            if isActive {
                                selectedTypes.removeAll { $0 == type.id }
                            } else {
                                selectedTypes.append(type.id)
                            }
                        }
                }
                // Animate grid changes when the selection set changes.
                .animation(.easeInOut(duration: 0.15), value: selectedTypes)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 20)
            .padding(.horizontal, 25)
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    Button("Clean All") {
                        // Clear selection and immediately apply/dismiss.
                        selectedTypes.removeAll()
                        applyFilters()
                        dismiss()
                    }
                }
                 ToolbarItem(placement: .topBarTrailing) {
                     Button {
                         // Apply chosen filters and close the sheet.
                         applyFilters()
                         dismiss()
                     } label: {
                         Text("Apply")
                             .foregroundStyle(hasSelectedTypes ? .white : .gray.opacity(0.7))
                     }
                     // Disable when no types selected to prevent a no-op.
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
    
    // MARK: - Computed Properties
    /// Whether any type is currently selected (used to enable/disable the Apply button).
    private var hasSelectedTypes: Bool {
        !selectedTypes.isEmpty
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
