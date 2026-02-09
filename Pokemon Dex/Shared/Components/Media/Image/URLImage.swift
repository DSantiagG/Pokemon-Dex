//
//  URLImage.swift
//  Pokemon Dex
//
//  Created by David Giron on 20/10/25.
//

import SwiftUI

/// A lightweight image view that loads, caches, and displays a remote image URL.
///
/// `URLImage` uses an internal ``URLImageViewModel`` to perform the network
/// request and exposes three visual states: loaded image, in-progress
/// progress indicator, and a placeholder when no image is available.
///
/// Example:
/// ```swift
/// URLImage(urlString: pokemon.sprites?.other?.officialArtwork?.frontDefault, cornerRadius: 8)
/// ```
struct URLImage: View {
    
    // MARK: - Properties
    
    /// Remote image URL string to load. If `nil` the placeholder state is shown.
    var urlString: String?
    /// Corner radius applied to the rendered image or placeholder.
    var cornerRadius: CGFloat = 0
    /// Content mode used when rendering the image.
    var contentMode: ContentMode = .fit
    
    // MARK: - State
    
    /// The loader ViewModel that performs fetching and caching.
    @StateObject private var loader = URLImageViewModel()
    
    // MARK: - View
    
    var body: some View {
        Group {
            if let image = loader.image {
                // Loaded image state
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else if loader.isLoading {
                // Loading state: show a circular progress view
                ZStack {
                    Color.gray.opacity(0.0)
                    ProgressView()
                }
                .aspectRatio(1, contentMode: contentMode)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius*3))
            } else {
                // Placeholder: empty background with a photo SF symbol
                Color.gray.opacity(0.0)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.8))
                    )
                    .aspectRatio(1, contentMode: contentMode)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius * 3))
            }
        }
        // When the urlString changes we cancel any previous load and start a new one
        .onChange(of: urlString) { _, new in
            loader.cancel()
            if let s = new, let url = URL(string: s) {
                loader.load(from: url)
            }
        }
        .onAppear {
            // Start loading when the view appears
            if let s = urlString, let url = URL(string: s) {
                loader.load(from: url)
            }
        }
        .onDisappear {
            // Cancel to avoid unnecessary network work when the view is off-screen
            loader.cancel()
        }
    }
}

#Preview ("Success"){
    URLImage(urlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")
}

#Preview ("Error"){
    Color.gray.opacity(0.5)
        .frame(width: 300, height: 200)
        .overlay {
            URLImage(urlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.pn")
        }
}
