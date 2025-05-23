//
//  LightBarGrow.swift
//  Snake
//
//  Created by Mohamed Mehiaoui on 5/23/25.
//

import Foundation
import SwiftUI

struct LightBarGrow: View {
    var totalWidth: CGFloat
    var height: CGFloat = 10

    @State private var currentWidth: CGFloat = 0
    @State private var animatePulse = false

    var body: some View {
        ZStack {
            // Barre lumineuse principale
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.yellow.opacity(0.95),
                            Color.orange.opacity(0.7),
                            Color.yellow.opacity(0.95)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: currentWidth, height: height)
                .cornerRadius(height / 2)
                .shadow(color: Color.yellow.opacity(animatePulse ? 1.0 : 0.3), radius: 15)

            // Particules
            ForEach(0..<15, id: \.self) { i in
                ParticleView(barWidth: totalWidth, barHeight: height)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5)) {
                currentWidth = totalWidth
            }
            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                animatePulse.toggle()
            }
        }
    }
}

