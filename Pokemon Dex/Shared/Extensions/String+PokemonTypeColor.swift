//
//  String+PokemonTypeColor.swift
//  Pokemon Dex
//
//  Created by David Giron on 9/11/25.
//

import SwiftUI
import PokemonAPI

extension String {
    var pokemonTypeColor: Color {
        switch self.lowercased() {
        case "fire": return .red
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "psychic": return .purple
        case "ice": return .cyan
        case "fighting": return .brown
        case "poison": return .indigo
        case "ground": return .orange
        case "flying": return .teal
        case "bug": return .green.opacity(0.8)
        case "rock": return Color(red: 182/255, green: 161/255, blue: 54/255)
        case "ghost": return .purple.opacity(0.7)
        case "dragon": return Color(red: 83/255, green: 164/255, blue: 207/255)
        case "dark": return .black
        case "steel": return .gray.opacity(0.6)
        case "fairy": return .pink
        case "normal": return Color(red: 168/255, green: 167/255, blue: 122/255)
        default: return .gray
        }
    }
}
