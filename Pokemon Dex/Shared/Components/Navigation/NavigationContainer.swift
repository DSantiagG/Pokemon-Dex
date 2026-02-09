//
//  NavigationContainer.swift
//  Pokemon Dex
//
//  Created by David Giron on 12/11/25.
//
import SwiftUI

/// A lightweight navigation wrapper that supplies the app's `NavigationRouter` to child views
/// and resolves `AppRoute` destinations into concrete detail views.
///
/// Wrap top-level content inside `NavigationContainer` when you need to use the
/// shared ``NavigationRouter`` for programmatic navigation. The container exposes a
/// `NavigationStack` that binds to the router's path and maps `NavigationRouter.AppRoute`
/// cases to the corresponding detail views.
///
/// Example:
/// ```swift
/// NavigationContainer {
///     PokemonHomeView()
/// }
/// .environmentObject(NavigationRouter())
/// ```
struct NavigationContainer<Content: View>: View {
    
    // MARK: - Environment
    
    /// Shared navigation router injected into the environment. Use the router
    /// to push/pop routes from any descendant view.
    @EnvironmentObject private var router: NavigationRouter
    
    // MARK: - Properties
    
    /// Content closure producing the root view shown inside the navigation stack.
    private let content: () -> Content
    
    // MARK: - Init
    
    /// Create a navigation container for the supplied content closure.
    ///
    /// - Parameter content: A `ViewBuilder` closure that returns the root content.
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    // MARK: - Body
    
    /// The container's body: a `NavigationStack` bound to the router's path.
    ///
    /// Destination resolution is provided by the `navigationDestination(for:)`
    /// modifier which switches over ``NavigationRouter/AppRoute`` and returns the
    /// appropriate detail view (for example ``PokemonDetailView``, ``AbilityDetailView``,
    /// and ``ItemDetailView``).
    var body: some View {
        NavigationStack (path: $router.path){
            content()
                .navigationDestination(for: NavigationRouter.AppRoute.self) { route in
                    switch route{
                    case .pokemonDetail(name: let name):
                        PokemonDetailView(pokemonName: name)
                    case .abilityDetail(name: let name):
                        AbilityDetailView(abilityName: name)
                    case .itemDetail(name: let name):
                        ItemDetailView(itemName: name)
                    }
                }
        }
    }
}

#Preview {
    NavigationContainer{
        EmptyView()
    }
    .environmentObject(NavigationRouter())
}
