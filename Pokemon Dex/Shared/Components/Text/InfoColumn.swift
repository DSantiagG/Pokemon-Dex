//
//  InfoColumn.swift
//  Pokemon Dex
//
//  Created by David Giron on 2/12/25.
//
import SwiftUI

/// A vertical info column that displays a title and a descriptive value.
///
/// - Parameters:
///   - title: The title label for the column (e.g., "Height").
///   - color: Accent color used for the value text.
///   - content: The view displayed beneath the title.
struct InfoColumn<Content: View>: View {
    
    let title: String
    let color: Color
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .foregroundStyle(color)
                .fontWeight(.medium)
            content
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    InfoColumn(title: "Capture Rate", color: .green){
        Text("80")
    }
}
