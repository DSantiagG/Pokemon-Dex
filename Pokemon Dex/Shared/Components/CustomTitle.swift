//
//  CustomTitle.swift
//  Pokemon Dex
//
//  Created by David Giron on 11/12/25.
//

import SwiftUI

struct CustomTitle: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 32, weight: .black, design: .rounded))
            .foregroundStyle(
                LinearGradient(colors: [.red, .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}

#Preview {
    CustomTitle(title: "Pokemon")
}
