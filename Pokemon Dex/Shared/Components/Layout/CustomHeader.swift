//
//  PokemonHeader.swift
//  Pokemon Dex
//
//  Created by David Giron on 23/11/25.
//

import SwiftUI
import PokemonAPI

/// A decorative, adaptive header used on detail screens.
///
/// `CustomHeader` draws a rounded, colored banner that hosts the primary
/// artwork (via `imageURL`) and an optional sound playback button. The header
/// supports a subtle parallax/stretch effect driven by the enclosing
/// `GeometryReader` so the artwork and background respond to vertical scroll.
///
/// - Parameters:
///   - color: Primary tint used for the header background, shadow and accent.
///   - imageURL: Optional remote image URL shown as the main artwork.
///   - showSoundButton: When `true` displays an `AudioPlayerButton` overlay.
///   - soundURL: Optional remote audio URL passed to the player.
struct CustomHeader: View {
    
    // MARK: - Properties
    
    let color: Color
    let imageURL: String?
    var showSoundButton: Bool = true
    var soundURL: String? = nil
    
    // MARK: - View
    
    /// The header body. It uses a `GeometryReader` to expose the vertical
    /// position (`minY`) and adjusts the background height, artwork offset,
    /// and overall translation to create a stretch/parallax effect.
    var body: some View {
        GeometryReader { proxy in
            let y = proxy.frame(in: .global).minY

            color
                .opacity(0.8)
                // The height increases when pulled down (y > 0) to create a stretch
                .frame(height: max(210 + (y > 0 ? y : 0), 200))
                .clipShape(customShape)
                .shadow(color: color.opacity(0.7), radius: 20)
                .overlay(
                    URLImage(urlString: imageURL, contentMode: .fit)
                        .frame(width: 310, height: 310)
                        .shadow(color: color, radius: 3)
                        .overlay(
                            ZStack {
                                if showSoundButton {
                                    AudioPlayerButton(urlString: soundURL, color: color, iconSize: 35)
                                        .padding(.trailing, 25)
                                        .padding(.bottom, 20)
                                        // Slight horizontal offset to visually separate the button
                                        .offset(x: 50)
                                }
                            },
                            alignment: .bottomTrailing
                        )
                        // Move the artwork down slightly and allow it to lag when pulled
                        // creating a subtle parallax: when y>0 the artwork moves half the pull distance
                        .offset(y: 60 + (y > 0 ? y/2 : 0))

                )
                // Translate the whole header up when scrolled up (negative y),
                // but keep it anchored when pulled down (positive y).
                .offset(y: (y > 0) ? -y : 0)
        }
        // Fixed frame for the header area; the internal GeometryReader drives the visual effects
        .frame(height: 210)
    }
    
    // MARK: - Helpers
    
    /// The custom rounded shape used to clip the header background.
    ///
    /// Uses `UnevenRoundedRectangle` to create large bottom corner radii that
    /// give the header its distinctive swooping appearance.
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
        CustomHeader(
            color: .green,
            imageURL: PokemonMockFactory.mockBulbasaur().sprites?.other?.officialArtwork?.frontDefault,
            soundURL: PokemonMockFactory.mockBulbasaur().cries?.latest)
        .padding(.bottom, 87)
    }
}
