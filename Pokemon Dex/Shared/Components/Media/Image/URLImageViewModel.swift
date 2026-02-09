//
//  URLImageViewModel.swift
//  Pokemon Dex
//
//  Created by David Giron on 20/10/25.
//

import Foundation
import SwiftUI
import Combine

/// View model responsible for loading remote images and exposing a `Image` for UI consumption.
///
/// `URLImageViewModel` manages an in-memory cache, a simple URLSession data task for loading
/// image data, and cancellation when the view disappears or the URL changes. The view model
/// publishes `image` when a `UIImage` is decoded successfully and sets `isLoading` while
/// a request is in-flight.
///
/// Example:
/// ```swift
/// @StateObject private var loader = URLImageViewModel()
/// loader.load(from: URL(string: "https://.../1.png")!)
/// ```
final class URLImageViewModel: ObservableObject {
    
    // MARK: - Published
    
    /// The SwiftUI `Image` produced from downloaded image data. Use this directly in views.
    @Published private(set) var image: Image?
    /// Whether a load is currently in progress.
    @Published private(set) var isLoading: Bool = false
    
    // MARK: - Private
    
    /// Shared in-memory cache for decoded `UIImage` instances keyed by absolute URL string.
    /// This lightweight cache avoids refetching when the same artwork is requested repeatedly.
    private static var imageCache = NSCache<NSString, UIImage>()
    private var dataTask: URLSessionDataTask?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public API
    
    /// Load an image from `url`. If the image is cached the cached value is applied immediately.
    /// Any previously active request is canceled before starting the new one.
    ///
    /// - Parameter url: Remote image URL to fetch.
    func load(from url: URL) {
        // Cancel previous work — only one active request at a time for this loader
        cancel()

        // Immediately return cached image if present
        if let cached = Self.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = Image(uiImage: cached)
            self.isLoading = false
            return
        }

        isLoading = true

        // Use URLSession dataTask for maximum control (caching is handled above)
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 30)

        dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            defer { DispatchQueue.main.async { self.isLoading = false } }

            if let error = error {
                // Network or decoding error — leave `image` nil and surface diagnostics
                print("URLImage load error: \(error)")
                return
            }

            guard let data = data, let uiImage = UIImage(data: data) else {
                // Received invalid data — nothing to set
                return
            }

            // Cache decoded image for future requests
            Self.imageCache.setObject(uiImage, forKey: url.absoluteString as NSString)

            // Publish the SwiftUI Image on the main thread
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
            }
        }

        dataTask?.resume()
    }
    
    /// Cancel any active load request and mark the loader as not loading.
    func cancel() {
        dataTask?.cancel()
        dataTask = nil
        isLoading = false
    }
}
