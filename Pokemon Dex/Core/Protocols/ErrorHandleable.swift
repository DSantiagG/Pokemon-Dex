//
//  ErrorHandleable.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import PokemonAPI

// MARK: - Error Handleable Protocol

/// Protocol that provides a standardized error handling helper for view models
/// and other types that manage a `ViewState`.
///
/// Conforming types must expose a mutable `state` property so the default
/// implementation can update UI state (for example `.error` or `.notFound`) in
/// response to failures.
@MainActor
protocol ErrorHandleable: AnyObject {
    /// The view state that will be updated by the default error handler.
    var state: ViewState { get set }
}

// MARK: - Default Implementation

@MainActor
extension ErrorHandleable {
    /// Default error handling routine used across the app.
    ///
    /// This function logs a debug message and handles an error by mapping it to a `ViewState` suitable for presentation:
    ///
    /// - Ignores cancellation-related errors.
    /// - Maps HTTP 404 responses to `.notFound`.
    /// - Presents a generic `.error` state for all other errors.
    ///
    /// - Parameters:
    ///   - error: The error that occurred.
    ///   - debugMessage: A short debug string to include in logs.
    ///   - userMessage: A user-facing message to display in the `.error` state.
    ///   - retry: A closure to be invoked when the user requests a retry.
    func handle(error: Error, debugMessage: String, userMessage: String, retry: @escaping () -> Void) {

        print("[DEBUG] \(debugMessage): \(error.localizedDescription)")

        if error is CancellationError { return }

        if let httpError = error as? HTTPError {
            switch httpError {
            case .serverResponse(let code, _):
                if code == .notFound {
                    state = .notFound
                    return
                }
            case .other(let error):
                if let urlError = error as? URLError, urlError.code == .cancelled {
                    return
                }
            default:
                break
            }
        }
        state = .error(message: userMessage, retryAction: retry)
    }
}
