import SwiftUI

struct ContentView: View {
    @StateObject private var game = SnakeGame()
    @State private var isNight = false
    @State private var level = 1
    
    let squareSize: CGFloat = 20
    let spacing: CGFloat = 2
    
    var body: some View {
        
        // Calculs des dimensions
        let plateWidth = CGFloat(game.columns) * (squareSize + spacing)
        let plateHeight = CGFloat(game.rows) * (squareSize + spacing)
        let baseWidth: CGFloat = 100    // tu ajustes cette valeur selon l'effet souhaité
        let height: CGFloat = 150
        
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
                
                ForEach(game.obstacles, id: \.self) { pos in
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: squareSize, height: squareSize)
                        .position(
                            x: CGFloat(pos.x) * (squareSize + spacing) + squareSize / 2,
                            y: CGFloat(pos.y) * (squareSize + spacing) + squareSize / 2
                        )
                }
                
                //Porte qui s'ouvre vers le prochain niveau
                
            }
            
            .frame(
                width: plateWidth,
                height: plateHeight
            )
            .padding()
            .background(Color.black)
            .onAppear {
                game.restartGame()
            }
            .overlay(
                ZStack {
                    if !game.isGameOver && game.score == 30{
                        // 🔥 Barre lumineuse au sommet du plateau
                        LightBarGrow(totalWidth: plateWidth - spacing)
                            .position(x: plateWidth / 2, y: 5)
                    }
                    if game.isGameOver {
                        VStack(spacing: 20) {
                            Text(game.gameOverMessage)
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(radius: 4)

                            if !game.gameOverMessage.isEmpty {
                                Text("💬 \(game.gameOverMessage)")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(maxWidth: 300)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.red.opacity(0.7))
                                    )
                                    .shadow(radius: 4)
                            }

                            if !game.JokeMessage.isEmpty {
                                VStack(spacing: 10) {
                                    Text(game.JokeMessage.isEmpty ? "Pas encore de blague" : game.JokeMessage)
                                        .foregroundColor(.white)
                                        .padding()


                                    Text("\"\(game.JokeMessage)\"")
                                        .font(.callout)
                                        .italic()
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding()
                                        .frame(maxWidth: 300)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue.opacity(0.6))
                                        )
                                        .shadow(radius: 4)
                                }
                                .padding(.top, 10)
                            }

                            Button("🔁 Rejouer") {
                                game.restartGame()
                            }
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 4)
                        }
                        .padding()
                        .background(Color.black.opacity(0.85))
                        .cornerRadius(20)
                        .padding()
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
