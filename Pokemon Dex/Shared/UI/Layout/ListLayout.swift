//
//  ListLayout.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//


/// Layout options used when rendering collections of cards or lists.
///
/// - `singleColumn`: Render items as a single vertical list (one column).
/// - `twoColumns`: Render items in a two-column grid.
///
/// The enum conforms to `String` and `Codable` so it can be persisted as a string
/// (for example in `UserDefaults`) and encoded/decoded with `JSONEncoder`/`JSONDecoder`.
///
/// Example:
/// ```swift
/// let layout: ListLayout = .twoColumns
/// UserDefaults.standard.set(layout.rawValue, forKey: "layout")
/// ```
enum ListLayout: String, Codable {
    case singleColumn
    case twoColumns
}
