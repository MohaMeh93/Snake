//
//  SnakeGameModelControl.swift
//  Snake
//
//  Created by Mohamed Mehiaoui on 5/16/25.
//

import Foundation
import Combine

//Structure pour les position sur la grille et dessiner le snake
struct Position: Equatable, Hashable{
    let x: Int
    let y: Int
}

// Déplacement automatique du snake : Direction
enum Direction {
    case up, down, left, right
}

//Differente maps
enum MapType {
    case empty
    case centralWall
    case labyrinth
    case randomWalls
    case floatingIslands
}



class SnakeGame: ObservableObject {
    let rows = 20
    let columns = 20
    
    @Published var snake: [Position] = [
        Position(x: 10, y: 10),
        Position(x: 10, y: 11),
        Position(x: 10, y: 12)
    ]
    
    //Tableau position d'obstacle
    @Published var obstacles: [Position] = []

    @Published var direction: Direction = .up
    @Published var isGameOver = false
    
    //Position de nourriture aleatoire
    @Published var food: Position? = nil
    //Blague au game over
    @Published var JokeMessage: String = ""
    
    //score
    @Published var score: Int = 0
    
    //Message raison de fin de jeu:
    @Published var gameOverMessage = ""
    
    //Porte qui souvre vers l prochain niveau
    @Published var levelGate: Bool = false
    
    //Niveau
    @Published var level: Int = 1

    
    private var timer: AnyCancellable?
    
    init() {
        startTimer()
    }
    
    //Generer les maps
    func generateMap(of type: MapType) {
        obstacles.removeAll()
        
        switch type {
        case .empty:
            break
            
        case .centralWall:
            let midX = columns / 2
            for y in 5..<(rows - 5) {
                obstacles.append(Position(x: midX, y: y))
            }

        case .labyrinth:
            for x in stride(from: 2, to: columns - 2, by: 4) {
                for y in 1..<(rows - 1) {
                    if y % 4 != 0 {
                        obstacles.append(Position(x: x, y: y))
                    }
                }
            }

        case .randomWalls:
            for _ in 0..<20 {
                let randX = Int.random(in: 0..<columns)
                let randY = Int.random(in: 0..<rows)
                let pos = Position(x: randX, y: randY)
                if !snake.contains(pos) && pos != food {
                    obstacles.append(pos)
                }
            }

        case .floatingIslands:
            let islands = [
                [Position(x: 3, y: 3), Position(x: 3, y: 4), Position(x: 4, y: 3)],
                [Position(x: columns - 5, y: 3), Position(x: columns - 5, y: 4)],
                [Position(x: columns / 2, y: rows - 4), Position(x: columns / 2 + 1, y: rows - 4)]
            ]
            for island in islands {
                obstacles.append(contentsOf: island)
            }
        }
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
        // ✅ NE RIEN FAIRE si on est en mode "porte activée"
        if levelGate == true {
            food = nil
            return
        }
        
        // Créer la liste des positions libres
        var freePositions = [Position]()
        for x in 0..<columns {
            for y in 0..<rows {
                let pos = Position(x: x, y: y)
                
                // Vérifie que la position n'est pas occupée par le serpent
                // (ajoute ici d'autres vérifs si tu veux exclure la porte)
                if !snake.contains(pos) {
                    freePositions.append(pos)
                }
            }
        }
        
        if freePositions.isEmpty {
            // Pas de place libre, jeu gagné
            food = nil
            gameOverMessage = "Tu as rempli tout le terrain, bravo !"
            endGame(reason: gameOverMessage)
            stopTimer()
            return
        }

        // Choisir une position libre aléatoire
        food = freePositions.randomElement()
    }

    //Fonction de fin de jeu:
    func endGame(reason: String) {
        stopTimer()

        isGameOver = true
        levelGate = false
        gameOverMessage = reason
    }


    
    func restartGame() {
        snake = [
            Position(x: 10, y: 10),
            Position(x: 10, y: 11),
            Position(x: 10, y: 12)
        ]
        score = 0
        direction = .up
        placeFood()
        isGameOver = false
        levelGate = false
        
        startTimer()
    }
    
    
    //Logique de jeu :
    
    //Gestion des mouvement du Serpent
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
        let gatePosition = Position(x: columns / 2, y: 0)
        if newHead.x <= 0 || newHead.x+1 == columns || newHead.y < 0 || newHead.y >= rows {
            
            if levelGate && newHead == gatePosition{
                level += 1
                score = 0
                levelGate = false
                
                generateMap(of: .centralWall)
                restartGame()
            }else{
                //arreter le jeu
                isGameOver = true
                endGame(reason: "Tu as perdu !")
                stopTimer()
                return
            }
            
        }
        
        
        //Collison avec un mur (obstacle)
        if obstacles.contains(newHead) {
            endGame(reason: "Tu as foncé dans un mur ! 🧱")
            return
        }
        
        snake.insert(newHead, at: 0)
        
        if newHead == food {
            score += 10

            // Active la porte une fois qu'on a atteint 30
            if score == 30 {
                levelGate = true
                food = nil
            }else{
                placeFood()
            }
        } else {
            // Pas mangé, on enlève la queue
            snake.removeLast()
        }
    }
    
}
