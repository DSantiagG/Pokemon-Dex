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
    let cryURL: String?
    
    var body: some View {
        
        GeometryReader { proxy in
            let y = proxy.frame(in: .global).minY
            
            color
                .opacity(0.8)
                .frame(height: max(220 + (y > 0 ? y : 0), 200))
                .clipShape(customShape)
                .shadow(color: color.opacity(0.7), radius: 20)
                .overlay(
                    URLImage(urlString: imageURL, contentMode: .fit)
                        .frame(width: 310, height: 310)
                        .shadow(color: color, radius: 3)
                        .overlay(
                            AudioPlayerButton(urlString: cryURL, color: color, iconSize: 35)
                                .padding(.trailing, 25)
                                .padding(.bottom, 20)
                                .offset(x: 50),
                            alignment: .bottomTrailing
                        )
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
        PokemonHeader(color: .green, imageURL: PokemonMockFactory.mockBulbasaur().sprites?.other?.officialArtwork?.frontDefault, cryURL: PokemonMockFactory.mockBulbasaur().cries?.latest)
            .padding(.bottom, 87)
    }
}
