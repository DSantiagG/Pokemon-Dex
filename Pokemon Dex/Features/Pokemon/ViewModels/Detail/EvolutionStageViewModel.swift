//
//  EvolutionStageViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//
import Foundation

/// Presentation view model for an evolution stage used by the detail UI.
///
/// Wraps a lightweight `EvolutionStage` and exposes presentation-friendly
/// properties (id, displayName, spriteURL) used by collection/grid views.
struct EvolutionStageViewModel: Identifiable {
    
    /// Backing ``EvolutionStage` model used to compute presentation properties.
    private let stage: EvolutionStage
    
    init(stage: EvolutionStage) {
        self.stage = stage
    }
    
    /// Stable identifier for SwiftUI lists; falls back to a generated UUID when the stage name is missing.
    var id: String {
        stage.name ?? UUID().uuidString
    }
    
    /// Raw name slug from the underlying model.
    var rawName: String? {
        stage.name
    }
    
    /// Human-friendly display name (capitalized / hyphen → space) or a fallback.
    var displayName: String {
        stage.name?.formattedName() ?? "Unknown Name"
    }
    
    /// Optional sprite URL string for the stage artwork.
    var spriteURL: String? {
        stage.sprite
    }
}
