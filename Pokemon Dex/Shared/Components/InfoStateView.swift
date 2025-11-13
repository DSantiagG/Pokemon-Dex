//
//  InfoStateView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

struct InfoStateView: View {
    let message: String
    
    @State private var animate = false
    @State private var showText = false

    var body: some View {
        ZStack {
            RadialGradient(
                    colors: [Color(red: 1, green: 0.95, blue: 0.9), Color.white],
                    center: .center,
                    startRadius: 50,
                    endRadius: 300
                )
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Image.pokemonPsyduck
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(animate ? 7 : -7))
                    .scaleEffect(animate ? 1.05 : 0.95)
                    .animation(.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                        value: animate
                    )
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
    InfoStateView(message: "No Pokémon found!\nTry searching again.")
}
