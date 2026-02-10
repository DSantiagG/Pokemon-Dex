//
//  InfoStateView.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//

import SwiftUI

/// A compact, friendly informational screen used to show empty/error states.
///
/// Presents a decorative illustration and two lines of text. Intended for
/// states such as "not found", "empty" or light error messaging where a
/// short title and supporting description are sufficient.
///
/// - Parameters:
///   - primaryText: The prominent headline shown to the user.
///   - secondaryText: A short supporting description displayed below the headline.
///
/// - Example:
/// ```swift
/// InfoStateView(primaryText: "No Pokémon found!", secondaryText: "Try searching again")
/// ```
struct InfoStateView: View {
    
    // MARK: - Parameters
    
    let primaryText: String
    let secondaryText: String
    
    // MARK: - State
    
    /// Controls the animation state of the illustration. When `true`, the image is rotated and scaled up slightly; when `false`, it's rotated in the opposite direction and scaled down. This state toggles on appear to create a continuous rocking animation.
    @State private var animate = false
    /// Controls the expansion state of the illustration. When `true`, the image scales up to 250x250; when `false`, it scales down to 220x220. This state toggles on tap to create a bounce effect.
    @State private var expand = false
    /// Controls the visibility of the text elements. When `true`, the primary and secondary text are shown with a fade-in transition; when `false`, they are hidden. This state is set to `true` shortly after the view appears to create a staggered reveal effect.
    @State private var showText = false
    
    // MARK: - View
    
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
