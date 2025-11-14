//
//  View+IfModifier.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/11/25.
//
import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool,
                             transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
