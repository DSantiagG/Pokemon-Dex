//
//  CardView.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//
import SwiftUI

struct CardView<Content: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var text: String
    var color: Color
    private let content: () -> Content

    init(text: String, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.text = text
        self.color = color
        self.content = content
    }
    
    var body: some View {
        VStack{
            content()
        }
        .padding()
        .padding(.vertical, 25)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(colorScheme == .light ? .white : .gray.opacity(0.2))
                .shadow(color: .black.opacity(0.04), radius: 8)
                .shadow(color: .black.opacity(0.05), radius: 20, y: 24)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.gray.opacity(0.4), lineWidth: 0.03)
                
        )
        .overlay (alignment: .top){
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
    CardView(text: "Evolution Chain", color: .green){
        Text("")
            .frame(height: 100)
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview ("Dark"){
    CardView(text: "Evolution Chain", color: .green){
        Text("")
            .frame(height: 100)
    }
    .padding()
    .preferredColorScheme(.dark)
}

