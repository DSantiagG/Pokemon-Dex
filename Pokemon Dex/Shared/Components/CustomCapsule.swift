//
//  CustomCapsule.swift
//  Pokemon Dex
//
//  Created by David Giron on 26/11/25.
//

import SwiftUI

struct CustomCapsule: View {
    
    var text: String
    var fontSize: Int = 17
    var fontWeight: Font.Weight?
    var color: Color
    var verticalPadding: CGFloat = 3
    var horizontalPadding: CGFloat = 10
    
    var body: some View {
        AdaptiveText(text: text)
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
