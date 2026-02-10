//
//  AudioPlayerButton.swift
//  Pokemon Dex
//
//  Created by David Giron on 1/12/25.
//


import SwiftUI
import AVFoundation

/// A compact play/pause button that plays audio from a remote URL.
///
/// Use this control to offer short audio playback  for a resource
/// identified by a URL string. The button automatically disables itself when
/// the provided URL is invalid or unsupported.
///
/// - Parameters:
///  - urlString: Remote audio URL as a string. If `nil` or invalid the button is disabled.
///  - color: Foreground color for the icon.
///  - iconSize: Size used for the SF Symbol icon (default: 44).
///
/// Example:
/// ```swift
/// AudioPlayerButton(urlString: "https://.../132.ogg", color: .green)
/// ```
struct AudioPlayerButton: View {
    
    // MARK: - State
    
    /// The AVPlayer instance used for playback. Kept in state so the view
    /// survives SwiftUI updates while the player remains active.
    @State private var player: AVPlayer?
    /// Tracks whether playback is currently active.
    @State private var isPlaying: Bool = false
    
    // MARK: - Props
    let urlString: String?
    var color: Color = .white
    var iconSize: CGFloat
    
    // MARK: - Init
    
    init(
        urlString: String?,
        color: Color = .white,
        iconSize: CGFloat = 44
    ) {
        self.urlString = urlString
        self.color = color
        self.iconSize = iconSize
    }
    
    // MARK: - View
    var body: some View {
        Button(action: onTap) {
            Image(systemName: iconName)
                .font(.system(size: iconSize))
                .foregroundStyle(color)
        }
        // disable the control when the URL is not playable
        .disabled(!canPlay)
        // observe when the player finishes a track
        .onReceive(playbackEndedPublisher, perform: handlePlaybackEnded)
        .onAppear {
            Task { @MainActor in
                // Ensure the app audio session is configured for playback
                AudioSessionConfigurator.configureIfNeeded()
            }
        }
    }
    
    // MARK: - Computed Properties
    
    /// Whether the control currently has a valid, supported URL to play.
    ///
    /// Returns `true` only when `urlString` can be parsed as an `http` or
    /// `https`
    private var canPlay: Bool {
        guard
            let urlString,
            let url = URL(string: urlString)
        else { return false }
        
        // Only allow HTTP(s) schemes here — local file support can be added
        // later if needed.
        return ["http", "https"].contains(url.scheme?.lowercased())
    }
    
    /// Name of the SF Symbol to display for the current playback state.
    ///
    /// Shows a disabled icon when playback cannot occur; otherwise toggles
    /// between play and pause icons based on `isPlaying`.
    private var iconName: String {
        guard canPlay else { return "play.slash.fill" }
        return isPlaying ? "pause.circle.fill" : "play.circle.fill"
    }
    
    /// A publisher that emits when an `AVPlayerItem` finishes playing.
    ///
    /// Observed by the view to reset the local `isPlaying` state when the
    /// currently-playing item reaches its end time.
    private var playbackEndedPublisher: NotificationCenter.Publisher {
        NotificationCenter.default.publisher(
            for: .AVPlayerItemDidPlayToEndTime
        )
    }
    
    // MARK: - Actions
    
    /// Toggle playback: play if stopped, pause if playing.
    private func onTap() {
        isPlaying ? pause() : play()
    }
    
    /// Start or restart playback for the current `urlString`.
    ///
    /// If the player is already set to the same remote URL the method seeks
    /// to the beginning; otherwise it replaces the player item.
    private func play() {
        guard
            let urlString,
            let url = URL(string: urlString)
        else { return }
        
        // If we're already playing the same URL restart from the beginning.
        if let currentItem = player?.currentItem,
           let asset = currentItem.asset as? AVURLAsset,
           asset.url == url
        {
            player?.seek(to: .zero)
        } else {
            // Replace the player item with a new one for the requested URL.
            let item = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: item)
        }
        player?.play()
        isPlaying = true
    }
    
    /// Pause playback and update the UI state.
    private func pause() {
        player?.pause()
        isPlaying = false
    }
    
    /// Handle the `AVPlayerItemDidPlayToEndTime` notification.
    ///
    /// - Parameter notification: The notification sent by `NotificationCenter`.
    ///   The implementation validates that the ended item matches the current
    ///   player's item before updating state.
    private func handlePlaybackEnded(_ notification: Notification) {
        guard
            let endedItem = notification.object as? AVPlayerItem, let currentItem = player?.currentItem, endedItem == currentItem
        else { return }
        
        isPlaying = false
    }
}

/// Small helper that configures the shared `AVAudioSession` for playback.
///
/// Kept private because it's an implementation detail of the control.
private enum AudioSessionConfigurator {

    static func configureIfNeeded() {
        let session = AVAudioSession.sharedInstance()

        // If already set to playback mode we don't need to do anything.
        guard session.category != .playback else { return }

        do {
            try session.setCategory(
                .playback,
                mode: .moviePlayback
            )
            try session.setActive(true)
        } catch {
            // Avoid crashing the UI — print for diagnostics.
            print("AudioSession error: \(error)")
        }
    }
}

#Preview ("Valid URL"){
    AudioPlayerButton(urlString: "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/132.ogg", color: .green)
}

#Preview ("Invalid URL"){
    AudioPlayerButton(urlString: nil, color: .green)
}
