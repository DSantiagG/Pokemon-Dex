//
//  ViewState.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//


import Foundation

// MARK: - View State

/// Represents the common UI loading state for views that fetch or display data.
///
/// Use this enum to drive view updates for loading, error and empty states.
enum ViewState {
    /// The view is idle and has not started loading content.
    case idle

    /// A loading operation is in progress.
    case loading

    /// Data was loaded successfully and can be displayed.
    case loaded

    /// No data was found for the current request (empty result).
    case notFound

    /// An error occurred while loading data.
    ///
    /// - Parameters:
    ///   - message: A user-facing message describing the error.
    ///   - retryAction: A closure that can be invoked to retry the failed operation.
    case error(message: String, retryAction: () -> Void)
}
