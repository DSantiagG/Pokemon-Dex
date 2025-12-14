//
//  ItemBasicInfoSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 13/12/25.
//

import SwiftUI

struct ItemBasicInfoSection: View {
    
    let name: String
    let category: String
    let cost: Int
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 15) {
            AdaptiveText(text: name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            HStack{
                CustomCapsule(text: name, fontSize: 19, fontWeight: .semibold, color: color, horizontalPadding: 15)
                
                HStack{
                    Image(systemName: "dollarsign.circle")
                        .font(.system(size: 21, weight: .bold))
                        .foregroundStyle(.orange)
                    Text("\(cost)")
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                }
                .padding(.vertical, 3)
                .padding(.horizontal, 15)
                .background(.orange.opacity(0.4))
                .clipShape(Capsule())
            }
            Text(description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ItemBasicInfoSection(name: "Master Ball", category: "Standard Balls", cost: 23, description: "The best ball that catches a Pokémon without fail", color: .red)
        .padding()
}
