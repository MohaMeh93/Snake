import SwiftUI

struct ContentView: View {
    @StateObject private var game = SnakeGame()
    @State private var isNight = false
    @State private var level = 1
    
    let squareSize: CGFloat = 20
    let spacing: CGFloat = 2
    
    var body: some View {
        VStack(spacing: 12) {
            GameStatusView(score: $game.score, level: $level, isNight: $isNight)
            ZStack {
                // Fond gris clair (case vide)
                //Color.gray.opacity(0.2)
                // Damier en fond
                VStack(spacing: spacing) {
                    ForEach(0..<game.rows, id: \.self) { row in
                        HStack(spacing: spacing) {
                            ForEach(0..<game.columns, id: \.self) { column in
                                let isEven = (row + column) % 2 == 0
                                Rectangle()
                                    .fill(isEven ? Color.gray.opacity(0.3) : Color.gray.opacity(0.15))
                                    .frame(width: squareSize, height: squareSize)
                            }
                        }
                    }
                }
                
                
                // Affichage nourriture (food)
                if let foodPos = game.food {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.green)
                        .frame(width: squareSize, height: squareSize)
                        .position(
                            x: CGFloat(foodPos.x) * (squareSize + spacing) + squareSize / 2,
                            y: CGFloat(foodPos.y) * (squareSize + spacing) + squareSize / 2
                        )
                }
                
                // 🌟 Vision nocturne (spot lumineux centré sur la tête)
                if isNight {
                    RadialGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.4), .clear]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 100
                    )
                    .blendMode(.screen)
                    .frame(width: 200, height: 200) // important pour que le dégradé soit visible
                    .position(
                        x: CGFloat(game.snake[0].x) * (squareSize + spacing) + squareSize / 2,
                        y: CGFloat(game.snake[0].y) * (squareSize + spacing) + squareSize / 2
                    )
                }
                
                // Affichage serpent
                ForEach(game.snake.indices, id: \.self) { index in
                    let pos = game.snake[index]
                    let isHead = (index == 0)
                    let isTail = (index == game.snake.count - 1)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isHead ? Color.green : (isTail ? Color.red.opacity(0.6) : Color.red))
                        .frame(width: squareSize, height: squareSize)
                        .overlay(
                            isHead ? EyesView() : nil
                        )
                        .position(
                            x: CGFloat(pos.x) * (squareSize + spacing) + squareSize / 2,
                            y: CGFloat(pos.y) * (squareSize + spacing) + squareSize / 2
                        )
                }
            }
            .frame(
                width: CGFloat(game.columns) * (squareSize + spacing),
                height: CGFloat(game.rows) * (squareSize + spacing)
            )
            .padding()
            .background(Color.black)
            .onAppear {
                game.restartGame()
            }
            .overlay(
                Group {
                    if game.isGameOver {
                        VStack(spacing: 20) {
                            Text("Game Over")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            if !game.gameOverMessage.isEmpty {
                                Text("💬 \(game.gameOverMessage)")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                            Button("Rejouer") {
                                game.restartGame()
                            }
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.9))
                        .cornerRadius(15)
                    }
                }
            )
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width
                        let verticalAmount = value.translation.height
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            if horizontalAmount < 0 {
                                game.changeDirection(.left)
                            } else {
                                game.changeDirection(.right)
                            }
                        } else {
                            if verticalAmount < 0 {
                                game.changeDirection(.up)
                            } else {
                                game.changeDirection(.down)
                            }
                        }
                    }
            )
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: 1.5)) {
                        isNight.toggle()
                    }
                }
            }
        }
    }
}

struct EyesView: View {
    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Color.white).frame(width: 5, height: 5)
            Circle().fill(Color.white).frame(width: 5, height: 5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
