//
//  SnakeGameModelControl.swift
//  Snake
//
//  Created by Mohamed Mehiaoui on 5/16/25.
//

import Foundation
import Combine

//Structure pour les position sur la grille et dessiner le snake
struct Position: Equatable{
    let x: Int
    let y: Int
}

// Déplacement automatique du snake : Direction
enum Direction {
    case up, down, left, right
}

class SnakeGame: ObservableObject {
    let rows = 20
    let columns = 20
    
    @Published var snake: [Position] = [
        Position(x: 10, y: 10),
        Position(x: 10, y: 11),
        Position(x: 10, y: 12)
    ]
    
    @Published var direction: Direction = .up
    @Published var isGameOver = false
    
    //Position de nourriture aleatoire
    @Published var food: Position = Position(x: Int.random(in: 0..<20), y: Int.random(in: 0..<20))
    
    //Blague au game over
    @Published var gameOverMessage: String = ""

    
    private var timer: AnyCancellable?
    
    init() {
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.moveSnake()
            }
    }
    
    //Arrete le timer (mouvement du snake)
    func stopTimer() {
        timer?.cancel()
    }
    
    
    func moveSnake(){
        var newHead = snake.first!
        
        switch direction {
        case .up:
            newHead = Position(x: newHead.x, y: newHead.y - 1)
        case .down:
            newHead = Position(x: newHead.x, y: newHead.y + 1)
        case .left:
            newHead = Position(x: newHead.x - 1, y: newHead.y)
        case .right:
            newHead = Position(x: newHead.x + 1, y: newHead.y)
        }
        //Verfication collision bord de la fenetre
        if newHead.x < 0 || newHead.x >= columns || newHead.y < 0 || newHead.y >= rows {
                //arreter le jeu
                isGameOver = true
                fetchChuckJoke()
                stopTimer()
                return
        }
        snake.insert(newHead, at: 0)
        
        if newHead == food {
            // Snake a mangé la nourriture, on place une nouvelle pomme
            placeFood()
        } else {
            // Pas mangé, on enlève la queue
            snake.removeLast()
        }
    }
    
    func changeDirection(_ newDirection: Direction) {
        // Empêche le snake de faire demi-tour
        switch (direction, newDirection) {
        case (.up, .down), (.down, .up), (.left, .right), (.right, .left):
            return
        default:
            direction = newDirection
        }
    }
    
    func placeFood() {
        var newFood: Position
        repeat {
            newFood = Position(x: Int.random(in: 0..<columns), y: Int.random(in: 0..<rows))
        } while snake.contains(newFood)
        food = newFood
    }
    
    //Appel API pour recupere des blagues chuck norris
    func fetchChuckJoke() {
        guard let url = URL(string: "https://api.chucknorris.io/jokes/random") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            if let joke = try? JSONDecoder().decode(ChuckJoke.self, from: data) {
                DispatchQueue.main.async {
                    self.gameOverMessage = joke.value
                }
            }
        }.resume()
    }

    
    func restartGame() {
        snake = [
            Position(x: 10, y: 10),
            Position(x: 10, y: 11),
            Position(x: 10, y: 12)
        ]
        direction = .up
        placeFood()
        isGameOver = false
        startTimer()
    }
    
}
