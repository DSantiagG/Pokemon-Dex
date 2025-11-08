//
//  HomeView.swift
//  Pokemon Dex
//
//  Created by David Giron on 6/11/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Pokemon Dex")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.red)
                
                PokemonListView()
                
            }
        }
    }
}

#Preview {
    HomeView()
}
