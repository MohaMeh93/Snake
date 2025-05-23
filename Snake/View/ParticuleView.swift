//
//  ParticuleView.swift
//  Snake
//
//  Created by Mohamed Mehiaoui on 5/23/25.
//

import Foundation
import SwiftUI

struct ParticleView: View {
    var barWidth: CGFloat
    var barHeight: CGFloat

    @State private var x: CGFloat = .zero
    @State private var y: CGFloat = .zero
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .fill(Color.white.opacity(opacity))
            .frame(width: 4 * scale, height: 4 * scale)
            .position(x: x, y: y)
            .onAppear {
                animate()
            }
    }

    private func animate() {
        x = CGFloat.random(in: 0...barWidth)
        y = CGFloat.random(in: 0...barHeight)
        opacity = 0.0
        scale = 0.3

        withAnimation(Animation.easeOut(duration: 0.8).delay(Double.random(in: 0...1)).repeatForever()) {
            opacity = Double.random(in: 0.4...0.9)
            scale = CGFloat.random(in: 0.7...1.5)
        }
    }
}

