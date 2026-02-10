//
//  SectionCard.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//
import SwiftUI

/// A rounded card container used to present a titled section of content.
///
/// `SectionCard` provides a consistent visual treatment for grouped UI: a
/// rounded white (or dimmed) background, subtle shadows, and a capsule label
/// that floats above the top edge with a colored stroke. Use it to group
/// related controls or lists within a screen.
///
/// - Parameters:
///  - text: The title displayed in the floating capsule at the top of the card.
///  - color: The accent color used for the capsule stroke and subtle background tint.
///  - content: A view builder closure that produces the inner content of the card.
///
/// Example:
/// ```swift
/// SectionCard(text: "Evolution Chain", color: .green) {
///     EvolutionChainView()
/// }
/// ```
struct SectionCard<Content: View>: View {
    
    // MARK: - Environment
    
    /// Current color scheme (used to adjust background tint/shadowing).
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Properties
    
    var text: String
    var color: Color
    private let content: () -> Content

    // MARK: - Init
    
    init(text: String, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.text = text
        self.color = color
        self.content = content
    }
    
    // MARK: - View
    
    /// The card's visual layout.
    ///
    /// Renders the provided `content` inside a padded rounded rectangle. A
    /// small capsule containing `text` is overlaid at the top and stroked
    /// with the provided `color`. Shadows and background tint vary slightly
    /// between light and dark color schemes.
    var body: some View {
        VStack{
            content()
        }
        .padding()
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(
            // Rounded card background with subtle light/dark adjustments
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colorScheme == .light ? .white : .gray.opacity(0.2))
                .shadow(color: .black.opacity(0.04), radius: 8)
                .shadow(color: .black.opacity(0.05), radius: 20, y: 24)
        )
        .overlay(
            // Thin stroke to separate the card from the background
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.gray.opacity(0.4), lineWidth: 0.03)
        )
        .overlay (alignment: .top){
            // Floating capsule label: uses background material to blend nicely
            Text(text)
                .bold()
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .background(.background)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(color, lineWidth: 1))
                .offset(y: -12)
        }
        .padding(.top, 5)
    }
}

#Preview ("Light"){
    SectionCard(text: "Evolution Chain", color: .green){
        Text("")
            .frame(height: 100)
       
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview ("Dark"){
    SectionCard(text: "Evolution Chain", color: .green){
        Text("")
            .frame(height: 100)
    }
    .padding()
    .preferredColorScheme(.dark)
}
