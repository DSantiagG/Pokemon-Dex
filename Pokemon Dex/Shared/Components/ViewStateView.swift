//
//  LoadingStateView.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//
import SwiftUI
import Combine

protocol HasViewState {
    var state: ViewState { get }
}

struct ViewStateView<VM: ObservableObject & HasViewState, Content: View>: View {
    
    @EnvironmentObject private var viewModel: VM
    
    private let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        
        content()
        
        if case .loading = viewModel.state {
            LoadingView()
        }
        if case .error(let message, let retry) = viewModel.state {
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

private final class PreviewViewModel: ObservableObject, HasViewState {
    @Published var state: ViewState = .idle

    init(state: ViewState = .idle) {
        self.state = state
    }
}

#Preview("Loading") {
    ViewStateView <PreviewViewModel, Color> {
        Color.blue.opacity(0.2)
    }
    .environmentObject(PreviewViewModel(state: .loading))
}

 #Preview("Error") {
     ViewStateView <PreviewViewModel, EmptyView> {
         EmptyView()
     }
     .environmentObject(
         PreviewViewModel(
             state: .error(message: "Something went wrong.", retryAction: {})
         )
     )
 }
 

