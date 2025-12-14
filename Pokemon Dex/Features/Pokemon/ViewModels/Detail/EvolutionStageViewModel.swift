//
//  EvolutionStageViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//
import Foundation

struct EvolutionStageViewModel: Identifiable {
    private let stage: EvolutionStage
    
    init(stage: EvolutionStage) {
        self.stage = stage
    }
    
    var id: String {
        stage.name ?? UUID().uuidString
    }
    
    var rawName: String? {
        stage.name
    }
    
    var displayName: String {
        stage.name?.formattedName() ?? "Unknown Name"
    }
    
    var spriteURL: String? {
        stage.sprite
    }
}
