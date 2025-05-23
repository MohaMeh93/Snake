//
//  HomeView.swift
//  Snake
//
//  Created by Mohamed Mehiaoui on 5/23/25.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @State private var isGameStarted = false

    var body: some View {
        ZStack {
            // 🔲 Image de fond
            Image("serpentHomeImg") // Remplace "background" par le nom de ton asset
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            // 🔳 Overlay pour assombrir légèrement si besoin
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            // 🐍 Contenu principal
            VStack(spacing: 30) {
                Text("🐍 Snake")
                    .font(.system(size: 60, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
                    .shadow(radius: 10)

                Button(action: {
                    isGameStarted = true
                }) {
                    Text("▶︎ Play")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(radius: 8)
                }
            }
        }
        .fullScreenCover(isPresented: $isGameStarted) {
            ContentView() // Lance ton jeu ici
        }
    }
}
