//
//  InfoStateView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

struct InfoStateView: View {
    
    let primaryText: String
    let secondaryText: String
    
    @State private var animate = false
    @State private var expand = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            
            VStack() {
                Image.pokemonPsyduck
                    .resizable()
                    .scaledToFit()
                    .frame(width: expand ? 250 : 220, height: expand ? 250 : 220)
                    .shadow(color: .yellow, radius: 2)
                    .padding(.bottom, 20)
                    .rotationEffect(.degrees(animate ? 7 : -7))
                    .scaleEffect(animate ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                               value: animate
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 2)) { expand = true }
                        withAnimation(.easeInOut(duration: 2).delay(0.3)) { expand = false }
                    }
                    .onAppear { animate = true }
                
                if showText {
                    Text(primaryText)
                        .font(.system(size: 25, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        
                    Text(secondaryText)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn.delay(0.3)) {
                showText = true
            }
        }
    }
}

#Preview {
    InfoStateView(primaryText: "No Pokémon found!", secondaryText: "Try searching again")
        .preferredColorScheme(.light)
}
