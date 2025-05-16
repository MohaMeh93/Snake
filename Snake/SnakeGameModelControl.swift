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
                stopTimer()
                return
        }
        snake.insert(newHead, at: 0)
        snake.removeLast()
        
        print("Snake moved to: \(newHead)")
    }
    
    func restartGame() {
        snake = [
            Position(x: 10, y: 10),
            Position(x: 10, y: 11),
            Position(x: 10, y: 12)
        ]
        direction = .up
        isGameOver = false
        startTimer()
    }
    
}
