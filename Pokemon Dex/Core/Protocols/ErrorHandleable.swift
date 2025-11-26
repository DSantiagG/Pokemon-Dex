//
//  ErrorHandleable.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/11/25.
//

import Foundation
import PokemonAPI

@MainActor
protocol ErrorHandleable: AnyObject {
    var state: ViewState { get set }
}

@MainActor
extension ErrorHandleable {
    
    func handle(error: Error, debugMessage: String, userMessage: String, retry: @escaping () -> Void) {
        
        print("[DEBUG] \(debugMessage): \(error.localizedDescription)")
        
        if error is CancellationError { return }
        
        if let httpError = error as? HTTPError {
            switch httpError {
            case .serverResponse(let code, _):
                if code == .notFound {
                    state = .notFound
                    return
                }
            case .other(let error):
                if let urlError = error as? URLError, urlError.code == .cancelled {
                    return
                }
            default:
                break
            }
        }
        state = .error(message: userMessage, retryAction: retry)
    }
}
