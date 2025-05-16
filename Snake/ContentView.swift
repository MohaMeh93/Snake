//
//  ContentView.swift
//  Snake
//
//  Created by Mohamed Mehiaoui on 5/16/25.
//

import SwiftUI



struct ContentView: View {

    @State private var game = SnakeGame()
    
    var body: some View {
            VStack(spacing: 2) {
                ForEach(0..<game.rows, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<game.columns, id: \.self) { column in
                            Rectangle()
                                .fill(game.snake.contains(Position(x:column, y: row)) ? Color.red : Color.gray.opacity(0.2))
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .padding()
            .background(Color.black)
            .onAppear {
                game.restartGame()
            }
            .overlay(
                Group {
                    if game.isGameOver{
                        VStack(spacing: 20){
                            Text("Game Over")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Button("Rejouer"){
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
