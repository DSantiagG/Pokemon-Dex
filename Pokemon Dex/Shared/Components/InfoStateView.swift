//
//  InfoStateView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

struct InfoStateView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    let message: String
    
    @State private var animate = false
    @State private var expand = false
    @State private var showText = false
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(Color(red: 1, green: 0.95, blue: 0.9))
                .frame(width: 350, height: 350)
                .blur(radius: 50)
                .opacity(colorScheme == .dark ? 0.3 : 1)
            
            VStack(spacing: 25) {
                Image.pokemonPsyduck
                    .resizable()
                    .scaledToFit()
                    .frame(width: expand ? 320 : 220, height: expand ? 320 : 220)
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
                    Text(message)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 3), value: showText)
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn.delay(1)) {
                showText = true
            }
        }
    }
}

#Preview {
    InfoStateView(message: "No Pokémon found!\nTry searching again")
}
