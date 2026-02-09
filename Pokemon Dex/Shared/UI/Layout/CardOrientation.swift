//
//  CardOrientation.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//


/// Orientation used by card-like layout containers to select rendering direction.
///
/// - `.vertical`: Arrange content in a vertical stack.
/// - `.horizontal`: Arrange content in a horizontal row.
///
/// Example:
/// ```swift
/// let layout: CardOrientation = .vertical
/// ```
enum CardOrientation {
    case vertical
    case horizontal
}
