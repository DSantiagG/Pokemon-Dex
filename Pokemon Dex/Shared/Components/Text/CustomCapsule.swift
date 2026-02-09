//
//  CustomCapsule.swift
//  Pokemon Dex
//
//  Created by David Giron on 26/11/25.
//

import SwiftUI

/// A capsule-shaped label used to display small badges or types.
///
/// - Parameters:
///   - text: The label text shown inside the capsule.
///   - fontSize: Font size used for the label.
///   - fontWeight: Optional font weight for the label text.
///   - color: Accent color used for the capsule background.
///   - verticalPadding: Vertical padding inside the capsule.
///   - horizontalPadding: Horizontal padding inside the capsule.
///   - isMultiline: Whether the inner text may wrap into multiple lines.
struct CustomCapsule: View {
    
    var text: String
    var fontSize: Int = 17
    var fontWeight: Font.Weight?
    var color: Color
    var verticalPadding: CGFloat = 3
    var horizontalPadding: CGFloat = 10
    var isMultiline = true
    
    var body: some View {
        AdaptiveText(text: text, isMultiline: isMultiline)
            .foregroundStyle(Color.white)
            .font(.system(size: CGFloat(fontSize), weight: fontWeight))
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(color)
            .clipShape(Capsule())
    }
}

#Preview {
    CustomCapsule(text: "Grass", fontWeight: .semibold, color: .green)
}
