//
//  PresentationOptionsMenu.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//


import SwiftUI

struct PresentationOptionsMenu: View {
    
    @Binding var layout: ListLayout
    var showsFilters: Bool = false
    var onFiltersTapped: (() -> Void)? = nil
    
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
            if showsFilters {
                Divider()
                
                Button {
                    onFiltersTapped?()
                } label: {
                    Label(
                        "Filters",
                        systemImage: "line.3.horizontal.decrease.circle"
                    )
                }
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
        }
    }
}

#Preview {
    PresentationOptionsMenu(layout: .constant(.twoColumns), showsFilters: true)
}
