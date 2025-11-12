//
//  AbilityDetailView.swift
//  Pokemon Dex
//
//  Created by David Giron on 10/11/25.
//

import SwiftUI

struct AbilityDetailView: View {
    @State var abilityName: String
    
    var body: some View {
        VStack{
            
        }
        .navigationTitle(Text(abilityName))
    }
}

#Preview {
    AbilityDetailView(abilityName: "Fire")
}
