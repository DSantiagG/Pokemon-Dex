//
//  AbilityBasicInfoSection.swift
//  Pokemon Dex
//
//  Created by David Giron on 4/12/25.
//
import SwiftUI

struct AbilityBasicInfoSection: View {
    
    var name: String
    var generation: String
    var description: String
    var color: Color
    
    var body: some View{
        
        header
            .frame(height: 85)
        
        VStack (spacing: 16){
            CustomCapsule(text: generation, fontWeight: .semibold, color: color, horizontalPadding: 15)
            
            Text(description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
    
    private var header: some View {
        GeometryReader { proxy in
            let y = proxy.frame(in: .global).minY
            let stretch = max(80 + (y > 0 ? y : 0), 80)
            let offset = y > 0 ? -y : 0
            let titleOffset = 1 + (y > 0 ? y/2 : 0)
            
            color
                .opacity(0.8)
                .frame(height: stretch)
                .clipShape(headerShape)
                .shadow(color: color.opacity(0.7), radius: 15)
                .overlay(
                    Text(name.formattedName())
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .offset(y: titleOffset)
                )
                .offset(y: offset)
        }
    }
    
    private var headerShape: UnevenRoundedRectangle {
        UnevenRoundedRectangle(
            topLeadingRadius: 0,
            bottomLeadingRadius: 100,
            bottomTrailingRadius: 100,
            topTrailingRadius: 0
        )
    }
}

#Preview {
    ScrollView{
        AbilityBasicInfoSection(name: "stench", generation: "Generation III", description: "Helps repel wild Pokemon.", color: .green)
            .padding(.bottom)
    }
    
}
