//
//  CardContainer.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/12/25.
//


import SwiftUI

struct CardContainer<VerticalContent: View, HorizontalContent: View>: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let color: Color
    let layout: CardOrientation
    @ViewBuilder let contentVertical: () -> VerticalContent
    @ViewBuilder let contentHorizontal: () -> HorizontalContent
    
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
