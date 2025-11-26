//
//  PokemonHeader.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//

import SwiftUI
import PokemonAPI

struct PokemonHeader: View {
    let color: Color
    let imageURL: String?
    
    var body: some View {
        
        GeometryReader { proxy in
            let y = proxy.frame(in: .global).minY
            
            color
                .opacity(0.8)
                .frame(height: max(220 + (y > 0 ? y : 0), 200))
                .clipShape(customShape)
                .overlay(customShape.stroke(color, lineWidth: 1))
                .shadow(color: color.opacity(0.7), radius: 20)
                .overlay(
                    URLImage(urlString: imageURL, contentMode: .fit)
                    .frame(width: 310, height: 310)
                    .shadow(color: color, radius: 3)
                    .offset(y: 60 + (y > 0 ? y/2 : 0))
                )
                .offset(y: (y > 0) ? -y : 0)
        }
        .frame(height: 220)
    }
    
    private var customShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: 160,
            bottomTrailingRadius: 160,
            topTrailingRadius: 0
        )
    }
}

#Preview{
    ScrollView{
        PokemonHeader(color: .green, imageURL: PokemonMockFactory.mockBulbasaur().sprites?.other?.officialArtwork?.frontDefault ?? "")
            .padding(.bottom, 87)
    }
}
