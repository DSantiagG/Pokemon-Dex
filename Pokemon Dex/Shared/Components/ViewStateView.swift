//
//  ViewStateView.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//
import SwiftUI
import Combine

struct ViewStateView<VM: ObservableObject & HasViewState, Content: View>: View {
    
    @ObservedObject private var viewModel: VM
    private let content: () -> Content
    
    init(viewModel: VM, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
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
    
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image.pokeball
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .rotationEffect(.degrees(animate ? 360 : 0))
                .animation(.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
                .onAppear {
                    animate = true
                }
            
            Text("Loading...")
                .font(.headline)
                .foregroundStyle(.red)
                .bold()
        }
        .padding()
    }
}

struct ErrorView: View {
    var message: String
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 9) {
            Image.pokemonPsyduck
                .resizable()
                .scaledToFit()
                .frame(height: 60)
            
            Text(message)
                .multilineTextAlignment(.center)
                .bold()
                .foregroundStyle(.blue)
            
            Button("Retry", action: retryAction)
                .buttonStyle(.borderedProminent)
                .bold()
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
    ViewStateView(viewModel: PreviewViewModel(state: .loading)){
        EmptyView()
    }
}

#Preview("Error") {
    ViewStateView(viewModel: PreviewViewModel(
        state: .error(message: "Something went wrong.", retryAction: {})
    )) {
        EmptyView()
    }
}
