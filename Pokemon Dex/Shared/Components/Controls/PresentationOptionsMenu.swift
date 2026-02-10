//
//  PresentationOptionsMenu.swift
//  Pokemon Dex
//
//  Created by David Giron on 14/12/25.
//


import SwiftUI

/// A compact menu that lets the user select a list presentation layout.
///
/// Use this menu to switch between the available ``ListLayout`` options (for
/// example grid vs list). The control binds to a ``ListLayout`` so selection
/// updates propagate to the parent view immediately.
///
/// - Parameters:
///  - layout: A binding to the current list layout. Updated when the user selects a different presentation.
///
/// Example:
/// ```swift
/// @State private var layout: ListLayout = .twoColumns
/// PresentationOptionsMenu(layout: $layout)
/// ```
struct PresentationOptionsMenu: View {
    
    // MARK: - Properties
    @Binding var layout: ListLayout
    
    // MARK: - View
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
