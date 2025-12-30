//
//  ColumnDivider.swift
//  Pokemon Dex
//
//  Created by David Giron on 2/12/25.
//
import SwiftUI

struct ColumnDivider: View {
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
