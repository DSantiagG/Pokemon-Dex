//
//  CustomAsyncImage.swift
//  Game Stream
//
//  Created by David Giron on 20/10/25.
//

import SwiftUI

struct URLImage: View {
    var urlString: String?
    var cornerRadius: CGFloat = 0
    var contentMode: ContentMode = .fit

    @State private var reloadToken = UUID()
    @State private var retryCount = 0
    private let maxRetries = 2
    
    var body: some View {
        if let urlString,
           let url = URL(string: urlString) {
            
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.0)
                        ProgressView()
                    }
                    .aspectRatio(1, contentMode: contentMode)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius*3))
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .onAppear {
                            if retryCount != 0 { retryCount = 0 }
                        }
                    
                case .failure:
                    ZStack {
                        Color.gray.opacity(0.1)
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius*3))
                    .aspectRatio(1, contentMode: contentMode)
                    .onAppear {
                        if retryCount < maxRetries {
                            let delay: TimeInterval = 0.6
                            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                                retryCount += 1
                                reloadToken = UUID()
                            }
                        }
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .id("\(urlString).\(reloadToken)")
            .onChange(of: urlString) { _, _ in
                retryCount = 0
                reloadToken = UUID()
            }
            
        } else {
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .aspectRatio(1, contentMode: contentMode)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius*3))
        }
    }
}

#Preview {
    URLImage(urlString: "https://cdn.cloudflare.steamstatic.com/steam/apps/292030/header.jpg")
    //URLImage(urlString: nil)
}
