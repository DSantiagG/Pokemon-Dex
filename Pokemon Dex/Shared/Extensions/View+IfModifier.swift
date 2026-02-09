//
//  View+IfModifier.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/11/25.
//
import SwiftUI

/// Small helper that conditionally applies a transformation to a `View`.
///
/// This extension provides a convenient `if(_:transform:)` modifier which
/// applies the supplied `transform` when `condition` is `true`, and returns
/// the original view unchanged when `condition` is `false`.
///
/// Example:
/// ```swift
/// Text("Hello")
///     .if(isHighlighted) { view in
///         view.foregroundColor(.red)
///     }
/// ```
extension View {
    /// Conditionally transform the view using the provided closure.
    ///
    /// - Parameters:
    ///   - condition: Whether to apply the `transform`.
    ///   - transform: A closure that receives the original view and returns a transformed view.
    /// - Returns: `Self` when `condition` is `false`, otherwise the result of `transform(self)`.
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
