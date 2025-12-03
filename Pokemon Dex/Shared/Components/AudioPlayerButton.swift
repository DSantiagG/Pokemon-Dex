//
//  AudioPlayerButton.swift
//  Pokemon Dex
//
//  Created by David Giron on 1/12/25.
//


import SwiftUI
import AVFoundation

struct AudioPlayerButton: View {
    let urlString: String?
    var color: Color = .white
    var iconSize: CGFloat = 44
    
    @State private var player: AVPlayer?
    @State private var isPlaying: Bool = false
    
    private var canPlay: Bool {
        guard let urlString, let url = URL(string: urlString) else { return false }
        return ["http", "https"].contains(url.scheme?.lowercased() ?? "")
    }
    
    var body: some View {
        Button(action: onTap) {
            Image(systemName: effectiveIconName)
                .font(.system(size: iconSize))
                .foregroundStyle(color)
        }
        .disabled(!canPlay)
        .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { notification in
            guard let endedItem = notification.object as? AVPlayerItem, let currentItem = player?.currentItem, endedItem == currentItem else { return }
            
            isPlaying = false
        }
        .onAppear {
            configureAudioSession()
        }
    }
    
    private var effectiveIconName: String {
        if !canPlay { return "play.slash.fill" }
        return isPlaying ? "pause.circle.fill" : "play.circle.fill"
    }
    
    private func onTap() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    private func play() {
        guard let urlString, let url = URL(string: urlString) else { return }
        
        if let currentItem = player?.currentItem,
           let asset = currentItem.asset as? AVURLAsset,
           asset.url == url {
            player?.seek(to: .zero)
        } else {
            let item = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: item)
        }
        player?.play()
        isPlaying = true
    }
    
    private func pause() {
        player?.pause()
        isPlaying = false
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error configurando AVAudioSession: \(error)")
        }
    }
}

#Preview ("Valid URL"){
    AudioPlayerButton(urlString: "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/132.ogg", color: .green)
}

#Preview ("Invalid URL"){
    AudioPlayerButton(urlString: nil, color: .green)
}
