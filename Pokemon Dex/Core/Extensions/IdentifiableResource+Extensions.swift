//
//  IdentifiableResource+Extensions.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/12/25.
//

import Foundation
import PokemonAPI

extension PKMAPIResource: IdentifiableResource {
    var resourceName: String { name ?? url ?? "unknown" }
}

extension PKMPokemon: IdentifiableResource {
    var resourceName: String { name ?? "unknown" }
}

extension PKMAbility: IdentifiableResource {
    var resourceName: String { name ?? "unknown" }
}
