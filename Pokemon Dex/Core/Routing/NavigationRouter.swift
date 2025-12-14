//
//  NavigationRouter.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//

import SwiftUI
import Combine

final class NavigationRouter: ObservableObject{
    @Published var path: [AppRoute] = []
    
    enum AppRoute: Hashable{
        case pokemonDetail(name: String)
        case abilityDetail(name: String)
        case itemDetail(name: String)
    }
    
    func push(_ route: AppRoute) {
        if path.last == route { return }
        
        if let index = path.firstIndex(of: route) {
            path = Array(path.prefix(index + 1))
        } else {
            path.append(route)
        }
    }
    
    func pop(){
        path.removeLast()
    }
    
    func popToRoot(){
        path.removeAll()
    }
}
