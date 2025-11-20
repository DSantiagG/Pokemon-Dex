//
//  NavigationRouter.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//

import SwiftUI
import Combine

final class NavigationRouter: ObservableObject{
    @Published var path: [Route] = []
    
    enum Route: Hashable{
        case pokemonDetail(name: String)
        case abilityDetail(name: String)
    }
    
    func push(_ route: Route) {
        if path.last == route { return }
        
        if let index = path.firstIndex(of: route) {
            let count = path.count - index - 1
            for _ in 0..<count {
                path.removeLast()
            }
            return
        }
        path.append(route)
    }
    
    func pop(){
        path.removeLast()
    }
    
    func popToRoot(){
        path.removeAll()
    }
}
