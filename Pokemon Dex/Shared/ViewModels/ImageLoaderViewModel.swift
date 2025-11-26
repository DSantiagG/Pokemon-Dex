//
//  ImageLoaderViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//
import Combine
import SwiftUI

final class ImageLoaderViewModel: ObservableObject {
    @Published var image: Image?
    @Published var isLoading = false

    private var task: Task<Void, Never>?

    func load(from url: URL, retries: Int = 2) {
        guard task == nil else { return }
        task = Task { [weak self] in
            guard let self else { return }
            self.isLoading = true
            defer {
                self.isLoading = false
                self.task = nil
            }
            var attempts = 0
            while attempts <= retries && !Task.isCancelled {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let ui = UIImage(data: data) {
                        await MainActor.run {
                            self.image = Image(uiImage: ui)
                        }
                        return
                    } else {
                        throw URLError(.cannotDecodeContentData)
                    }
                } catch {
                    if (error as? URLError)?.code == .cancelled { return }
                    attempts += 1
                    if attempts <= retries {
                        try? await Task.sleep(nanoseconds: 600_000_000) // 0.6s
                    }
                }
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
