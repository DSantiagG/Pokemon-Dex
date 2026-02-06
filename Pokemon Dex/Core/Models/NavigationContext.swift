//
//  NavigationContext.swift
//  Pokemon Dex
//
//  Created by David Giron on 4/12/25.
//


/// Describes the navigation context from which a navigation action originates.
///
/// Use this to distinguish between main-stack navigation and sheet-based
/// navigation so callers can adapt behavior (for example: dismissing a sheet
/// vs pushing onto a navigation stack).
enum NavigationContext {
    /// Represents navigation from the app's primary navigation stack.
    case main

    // MARK: - Sheets

    /// Represents navigation that should present a sheet. The nested ``SheetKind``
    /// identifies which feature the sheet belongs to.
    case sheet(SheetKind)

    /// Kinds of sheets used across the app. These values help callers decide how
    /// to route or dismiss a presented sheet.
    enum SheetKind {
        /// A sheet presenting Pokémon-related content.
        case pokemon
        /// A sheet presenting ability-related content.
        case ability
        /// A sheet presenting item-related content.
        case item
    }
}
