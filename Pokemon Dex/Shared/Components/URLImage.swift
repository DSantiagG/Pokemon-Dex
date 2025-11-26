//
//  URLImage.swift
//  Pokemon Dex
//
//  Created by David Giron on 20/10/25.
//

import SwiftUI

struct URLImage: View {
    var urlString: String?
    var cornerRadius: CGFloat = 0
    var contentMode: ContentMode = .fit
    
    @StateObject private var loader = ImageLoaderViewModel()
    
    var body: some View {
        Group {
            if let image = loader.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else if loader.isLoading {
                ZStack {
                    Color.gray.opacity(0.0)
                    ProgressView()
                }
                .aspectRatio(1, contentMode: contentMode)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius*3))
            } else {
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
        .onChange(of: urlString) { _, new in
            loader.cancel()
            if let s = new, let url = URL(string: s) {
                loader.load(from: url)
            }
        }
        .onAppear {
            if let s = urlString, let url = URL(string: s) {
                loader.load(from: url)
            }
        }
        .onDisappear {
            loader.cancel()
        }
    }
}

#Preview ("Success"){
    URLImage(urlString: "https://cdn.cloudflare.steamstatic.com/steam/apps/292030/header.jpg")
}

#Preview ("Error"){
    Color.gray.opacity(0.5)
        .frame(width: 300, height: 200)
        .overlay {
            URLImage(urlString: "https://cdn.cloudflare.steamstatic.com/steam/apps/292030/header.jp")
        }
}
