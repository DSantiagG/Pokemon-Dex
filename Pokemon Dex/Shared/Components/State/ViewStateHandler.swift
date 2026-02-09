//
//  ViewStateHandler.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//
import SwiftUI
import Combine

/// A small helper view that overlays loading and error UI states on top of content.
///
/// `ViewStateHandler` accepts a view model conforming to `ObservableObject & ErrorHandleable`
/// and a content closure. It renders the content and conditionally displays a
/// `LoadingView` when `viewModel.state` is `.loading` or an `ErrorView` when the
/// state is `.error(message:retryAction:)`.
///
/// Example:
/// ```swift
/// ViewStateHandler(viewModel: myViewModel) {
///     MyContentView()
/// }
/// ```
struct ViewStateHandler<VM: ObservableObject & ErrorHandleable, Content: View>: View {
    
    // MARK: - Stored Properties
    
    /// The observed view model providing the current UI state.
    ///
    /// Must conform to `ErrorHandleable` so the handler can display errors and
    /// expose retry actions provided by the view model.
    @ObservedObject private var viewModel: VM
    /// Closure producing the wrapped content displayed under the state overlays.
    private let content: () -> Content
    
    // MARK: - Init
    
    init(viewModel: VM, @ViewBuilder content: @escaping () -> Content) {
        self.viewModel = viewModel
        self.content = content
    }
    
    // MARK: - Body
    
    /// Renders the wrapped content and overlays state-driven UI elements.
    ///
    /// Loading and error UI are shown above the `content` so the caller doesn't
    /// need to manage those states manually.
    var body: some View {
        // Primary content provided by the caller
        content()
        
        // Show the loading indicator when the view model enters `.loading`
        if case .loading = viewModel.state {
            LoadingView()
        }
        // Show an error view when the view model reports `.error`
        if case .error(let message, let retry) = viewModel.state {
            ErrorView(message: message, retryAction: retry)
        }
    }
}

// MARK: - LoadingView

/// A simple spinning pokéball used to indicate an in-progress loading state.
///
/// The view animates rotation continuously while visible. The animation is
/// triggered in `onAppear` and uses a repeating linear rotation.
struct LoadingView: View {
    
    @State private var animate = false
    
    var body: some View {
        Image.pokeball
            .resizable()
            .scaledToFit()
            .frame(height: 50)
            .padding()
            // Rotate the image when `animate` becomes true
            .rotationEffect(.degrees(animate ? 360 : 0))
            .animation(.linear(duration: 0.7).repeatForever(autoreverses: false), value: animate)
            .onAppear {
                // Start the continuous rotation when the view appears
                animate = true
            }
    }
}

// MARK: - ErrorView

/// A compact error presentation that shows a friendly image, a message and a retry button.
///
/// The `retryAction` closure is invoked when the user taps "Retry" so callers can
/// retry the failed operation. UI styling uses a bold label and a capsule-styled
/// retry button to match the app's design language.
///
/// - Parameters:
///   - message: The user-facing error message to display inside the card.
///   - retryAction: Closure invoked when the user taps the "Retry" button.
struct ErrorView: View {
    /// The message presented to the user describing the error.
    var message: String
    /// Action invoked when the user requests a retry.
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 9) {
            Image.pokemonPsyduck
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                
            Text(message)
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                
            Button("Retry", action: retryAction)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .padding(.vertical, 3)
                .padding(.horizontal, 17)
                .background(.red.opacity(0.8))
                .clipShape(Capsule())
        }
        .padding()
    }
}

// MARK: - Preview helpers

private final class PreviewViewModel: ObservableObject, ErrorHandleable {
    @Published var state: ViewState = .idle
    init(state: ViewState = .idle) {
        self.state = state
    }
}

#Preview("Loading") {
    ViewStateHandler(viewModel: PreviewViewModel(state: .loading)){
        EmptyView()
    }
}

#Preview("Error") {
    ViewStateHandler(viewModel: PreviewViewModel(
        state: .error(message: "Something went wrong.", retryAction: {})
    )) {
        EmptyView()
    }
}
