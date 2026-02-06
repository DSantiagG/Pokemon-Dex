//
//  NavigationRouter.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//

import SwiftUI
import Combine

/// Simple navigation router that exposes a mutable navigation `path` used by
/// SwiftUI navigation stacks.
///
/// It models application routes via the nested ``AppRoute`` enum and provides
/// helpers to push/pop routes.
///
/// Example:
/// ```swift
/// let router = NavigationRouter()
/// router.push(.pokemonDetail(name: "bulbasaur"))
/// ```
final class NavigationRouter: ObservableObject{
    // MARK: - Path

    /// The current navigation path represented as an array of ``AppRoute``.
    @Published var path: [AppRoute] = []
    
    // MARK: - Routes

    /// Application routes used by the navigation stack.
    enum AppRoute: Hashable{
        /// Show a Pokémon detail view. The name may be nil.
        case pokemonDetail(name: String?)
        /// Show an ability detail view.
        case abilityDetail(name: String?)
        /// Show an item detail view.
        case itemDetail(name: String?)
    }
    
    // MARK: - Navigation API
    
    /// Push a new route onto the navigation path.
    ///
    /// If the pushed route already exists in the path it truncates the path to
    /// that route (prevents duplicate entries). If the last item equals the
    /// route, the call is ignored.
    func push(_ route: AppRoute) {
        if path.last == route { return }
        
        if let index = path.firstIndex(of: route) {
            path = Array(path.prefix(index + 1))
        } else {
            path.append(route)
        }
    }
    
    /// Pop the last route from the navigation path.
    func pop(){
        path.removeLast()
    }
    
    /// Remove all routes and return to the root.
    func popToRoot(){
        path.removeAll()
    }
}
