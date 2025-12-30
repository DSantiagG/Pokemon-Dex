//
//  PresentationOptionsMenu.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//


import SwiftUI

struct PresentationOptionsMenu: View {
    
    @Binding var layout: ListLayout
    
    var body: some View {
        Menu {
            Button {
                layout = .twoColumns
            } label: {
                Label(
                    "Grid",
                    systemImage: layout == .twoColumns ? "checkmark" : ""
                )
            }
            
            Button {
                layout = .singleColumn
            } label: {
                Label(
                    "List",
                    systemImage: layout == .singleColumn ? "checkmark" : ""
                )
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
}

#Preview {
    PresentationOptionsMenu(layout: .constant(.twoColumns))
}
