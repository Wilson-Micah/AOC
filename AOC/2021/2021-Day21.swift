//
//  2021-Day21.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Foundation

extension AOC21 {
    struct Day21: Day {
        func part1() -> String {
            let input = input.lines.map { line in
                Int(line.components(separatedBy: ": ")[1])!
            }
            var dieValue = 0
            var scores = [1: 0, 2: 0]
            var players = [1: input[0], 2: input[1]]
            
            var player = 1
            var totalRoles = 0
            while scores.values.max()! < 1000 {
                
                var roles = 0
                for _ in 0..<3 {
                    totalRoles += 1
                    dieValue += 1
                    roles += dieValue
                    if dieValue == 100 {
                        dieValue = 0
                    }
                }
                
                players[player, default: 0] = (players[player, default: 0] + roles - 1) % 10 + 1
                scores[player, default: 0] += players[player, default: 0]
                
                player = player == 1 ? 2 : 1
            }
            
            return "\(scores.values.min()! * totalRoles)"
        }
        
        struct Score: Hashable {
            var p1Position: Int
            var p2Position: Int
            var p1Score: Int
            var p2Score: Int
            
            var isFinished: Bool {
                p1Score >= 21 || p2Score >= 21
            }
        }
        
        func part2() -> String {
            let input = example.lines.map { line in
                Int(line.components(separatedBy: ": ")[1])!
            }
            var universes = [Score(p1Position: input[0], p2Position: input[1], p1Score: 0, p2Score: 0): 1]
            
            var playerOnesTurn = true
            while universes.keys.contains(where: { !$0.isFinished }) {
                let values = [3: 1, 4: 3, 5: 6, 6: 7, 7: 6, 8: 3, 9: 1]

                var unis = universes.filter { $0.key.isFinished }
                for (key, value) in values {
                    for (var scoreKey, scoreValue) in universes where !scoreKey.isFinished {
                        if playerOnesTurn {
                            scoreKey.p1Position = (scoreKey.p1Position + key - 1) % 10 + 1
                            scoreKey.p1Score += scoreKey.p1Position
                        } else {
                            scoreKey.p2Position = (scoreKey.p2Position + key - 1) % 10 + 1
                            scoreKey.p2Score += scoreKey.p2Position
                        }
                        unis[scoreKey, default: 0] += scoreValue * value
                    }
                }
                universes = unis

                playerOnesTurn.toggle()
            }
            
            let playerOneWins = universes.filter { $0.key.p1Score > $0.key.p2Score }.map(\.value).reduce(into: 0, +=)
            let playerTwoWins = universes.filter { $0.key.p2Score > $0.key.p1Score }.map(\.value).reduce(into: 0, +=)
            
            return "\(max(playerOneWins, playerTwoWins))"
        }
    }
}
