//
//  AbilityKind.swift
//  Pokemon Dex
//
//  Created by David Giron on 25/11/25.
//

/// Represents whether an ability entry is a normal or a hidden ability.
///
/// Use `AbilityKind` when classifying ability entries attached to a Pokémon.
enum AbilityKind: Hashable {
    /// The ability is a standard (visible) ability.
    case normal
    /// The ability is a hidden ability (rare/hidden slot).
    case hidden
}
