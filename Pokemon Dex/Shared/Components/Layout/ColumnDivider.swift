//
//  ColumnDivider.swift
//  Pokemon Dex
//
//  Created by David Giron on 2/12/25.
//
import SwiftUI

/// A compact vertical divider used between columns in an `HStack`.
///
/// Renders a full-height `Divider` with horizontal padding to separate
/// adjacent content while keeping layout consistent.
///
/// Example:
/// ```swift
/// HStack {
///     Text("Left")
///     ColumnDivider()
///     Text("Right")
/// }
/// ```
struct ColumnDivider: View {
    // MARK: - View
    var body: some View {
        Divider()
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 8)
    }
}

#Preview {
    HStack{
        Text("Text")
        ColumnDivider()
        Text("Text")
    }
}
