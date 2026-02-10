//
//  PokemonCard.swift
//  Pokemon Dex
//
//  Created by David Giron on 7/11/25.
//

import SwiftUI
import PokemonAPI

/// A compact card view that displays a single Pokémon's image, name, order and types.
///
/// - Parameters:
///   - pokemon: The `PKMPokemon` model to render.
///   - layout: The ``CardOrientation`` layout hint used to choose vertical or horizontal arrangement.
///
/// - Example:
/// ```swift
/// PokemonCard(pokemon: somePokemon, layout: .horizontal)
/// ```
struct PokemonCard: View {
    
    // MARK: - Environment
    /// System color scheme used to adjust shadowing and contrast for light/dark modes.
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Properties
    var pokemon: PKMPokemon
    var layout: CardOrientation = .vertical
    
    // MARK: - Computed Properties
    /// Primary tint color derived from the Pokémon's first type.
    /// Falls back to gray when no type information is available.
    private var pokemonColor: Color {
        // Use the first available type to theme the card
        pokemon.types?.first?.color ?? .gray
    }
    
    /// Formatted display name for UI.
    private var displayName: String {
        pokemon.name?.formattedName() ?? "Unknown Name"
    }
    
    /// Type names prepared for display as capsules.
    private var displayTypes: [String] {
        pokemon.types?.map { $0.type?.name?.formattedName() ?? "Unknown Type" } ?? []
    }
    
    // MARK: - Body
    
    var body: some View{
        CardContainer(color: pokemonColor, layout: layout) {
            VStack(alignment: .center, spacing: 8) {
                image
                title
                order
                types
            }
        } contentHorizontal: {
            HStack(spacing: 12) {
                image
                VStack(alignment: .leading, spacing: 4) {
                    title
                    types
                }
                Spacer()
                VStack{
                    Spacer()
                    order
                }
            }
        }
    }
    
    // MARK: - Subviews
    private var image: some View {
        // Use `URLImage` that handles caching and async loading for the artwork
        URLImage(
            urlString: pokemon.sprites?.other?.officialArtwork?.frontDefault,
            cornerRadius: 5,
            contentMode: .fit
        )
        // subtle shadow using the derived color to match the card tint
        .shadow(color: pokemonColor, radius: 6)
    }
    
    private var title: some View {
        AdaptiveText(text: displayName, isMultiline: false)
            .bold()
    }
    
    private var order: some View {
        Text(String(format: "#%03d", pokemon.id ?? 0))
            .font(.system(size: layout == .vertical ? 15 : 20, weight: .semibold, design: .rounded))
            .foregroundStyle(pokemonColor)
            .shadow(color: pokemonColor, radius: 4)
    }
    
    private var types: some View {
        HStack {
            ForEach(displayTypes, id: \.self) { type in
                CustomCapsule(text: type, color: type.pokemonTypeColor)
            }
        }
    }
    
    // MARK: - Previews
}

#Preview ("Vertical") {
    PokemonCard(pokemon: PokemonMockFactory.mockBulbasaur(), layout: .vertical)
        .padding()
}

#Preview ("Horizontal") {
    PokemonCard(pokemon: PokemonMockFactory.mockBulbasaur(), layout: .horizontal)
        .frame(height: 90)
        .padding()
}
