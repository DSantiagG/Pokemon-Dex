//
//  LoadingState.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/11/25.
//


enum ViewState {
    case idle
    case loading
    case loaded
    case error(message: String, retryAction: () -> Void)
}
