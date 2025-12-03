//
//  InfoColumn.swift
//  Pokemon Dex
//
//  Created by David Giron on 2/12/25.
//
import SwiftUI

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
