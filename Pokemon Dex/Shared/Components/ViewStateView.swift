//
//  LoadingStateView.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//
import SwiftUI

struct ViewStateView<Content: View>: View {
    @EnvironmentObject private var pokemonVM: PokemonViewModel
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        
        content
        
        if case .loading = pokemonVM.state {
            LoadingView()
        }
        if case .error(let message, let retry) = pokemonVM.state {
            ErrorView(message: message, retryAction: retry)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading...")
                .font(.headline)
        }
    }
}

struct ErrorView: View {
    var message: String
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text(message)
                .multilineTextAlignment(.center)
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ViewStateView{
        EmptyView()
    }
    .environmentObject(PokemonViewModel())
}
