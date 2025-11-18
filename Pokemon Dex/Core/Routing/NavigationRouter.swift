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
        // If the last item is already this route, do nothing
        if path.last == route {
            print("No hago nada \(path)")
            return }
        
        if let index = path.firstIndex(of: route) {
                // Pop until the existing route is top
                let count = path.count - index - 1
                for _ in 0..<count {
                    path.removeLast()
                }
                return
            }
        
        // Append the route to the end
        path.append(route)
        print("Agregue la ruta y el path quedo: \(path)")
    }
    
    func pop(){
        path.removeLast()
    }
    
    func popToRoot(){
        path.removeAll()
    }
}
