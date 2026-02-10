//
//  CardContainer.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//


import SwiftUI

/// A flexible card container that presents content in either a vertical or
/// horizontal layout depending on the provided ``CardOrientation``.
///
/// Use ``CardContainer`` to wrap related pieces of UI inside a rounded card with
/// padding, a subtle background tint derived from `color`, and a stroked border.
/// The container adapts its inner layout by calling either `contentVertical` or
/// `contentHorizontal` based on the `layout` value.
///
/// - Parameters:
///  - color: Primary color used for the card's tint and border.
///  - layout: Orientation that determines which content closure to render.
///  - contentVertical: Closure that produces the vertical arrangement of content.
///  - contentHorizontal: Closure that produces the horizontal arrangement of content.
///
/// Example:
/// ```swift
/// CardContainer(color: .red, layout: .vertical) {
///     VStack { Text("Vertical") }
/// } contentHorizontal: {
///     HStack { Text("Horizontal") }
/// }
/// ```
struct CardContainer<VerticalContent: View, HorizontalContent: View>: View {
    
    // MARK: - Environment
    
    /// Color scheme used to adjust background shadowing in light/dark modes.
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Properties
    
    let color: Color
    let layout: CardOrientation
    @ViewBuilder let contentVertical: () -> VerticalContent
    @ViewBuilder let contentHorizontal: () -> HorizontalContent
    
    // MARK: - View
    
    /// The card view body. Chooses the vertical or horizontal content path
    /// according to `layout`, applies consistent padding and a rounded
    /// background/tint, and draws a stroked border using `color`.
    ///
    /// Note: the implementation uses a conditional `.if` modifier to apply a
    /// shadow only in light mode (keeps the card subtle in dark mode).
    var body: some View {
        Group {
            switch layout {
            case .vertical:
                contentVertical()
            case .horizontal:
                contentHorizontal()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .if(colorScheme == .light) { view in
                    view.shadow(color: color.opacity(0.5), radius: 6)
                }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color, lineWidth: 1)
        )
    }
}

#Preview ("Vertical") {
    CardContainer(color: .red, layout: .vertical) {
        VStack{
            Text("Vertical Content")
            Text(".")
        }
    } contentHorizontal: {
        HStack{
            Text("Horizontal Content")
            Text(".")
        }
    }
    .padding()
}

#Preview ("Horizontal") {
    CardContainer(color: .red, layout: .horizontal) {
        VStack{
            Text("Vertical Content")
            Text(".")
        }
    } contentHorizontal: {
        HStack{
            Text("Horizontal Content")
            Text(".")
        }
    }
    .padding()
}
