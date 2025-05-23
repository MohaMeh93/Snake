//
//  GameStatutView.swift
//  Snake
//
//  Created by Mohamed Mehiaoui on 5/23/25.
//

import Foundation
import SwiftUI

struct GameStatusView: View {
    @Binding var score: Int
    @Binding var level: Int
    @Binding var isNight: Bool
    
    @ObservedObject var weatherVM: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            // Affichage météo au-dessus
            HStack {
                Image("nuageux")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(weatherVM.weatherDescription)
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
            }
            .padding(.bottom, 4)
            
            // Ton HStack actuel avec score, niveau, bouton jour/nuit
            HStack(spacing: 20) {
                // Score avec icône pomme
                HStack(spacing: 6) {
                    Image(systemName: "applelogo")
                        .foregroundColor(.red)
                        .font(.title3)
                        .shadow(color: .red, radius: 6)
                    Text("\(score)")
                        .font(.title3.bold())
                        .foregroundColor(.green)
                        .shadow(color: .green.opacity(0.7), radius: 6)
                }
                
                Spacer()
                
                // Niveau
                HStack(spacing: 6) {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                        .shadow(color: .yellow.opacity(0.8), radius: 6)
                    Text("Niveau \(level)")
                        .font(.title3.bold())
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow.opacity(0.7), radius: 6)
                }
                
                Spacer()
                
                // Bouton bascule Jour / Nuit
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isNight.toggle()
                    }
                } label: {
                    Image(systemName: isNight ? "moon.fill" : "sun.max.fill")
                        .font(.title2)
                        .foregroundColor(isNight ? .white : .yellow)
                        .shadow(color: isNight ? .white.opacity(0.8) : .yellow.opacity(0.8), radius: 10)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(isNight ? Color.black.opacity(0.7) : Color.yellow.opacity(0.3))
                                .shadow(radius: 8)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                Color.black.opacity(0.6)
                    .blur(radius: 12)
                    .cornerRadius(14)
                    .shadow(color: isNight ? .white.opacity(0.6) : .yellow.opacity(0.6), radius: 12)
            )
            .padding(.horizontal)
        }
    }
}
