//
//  2022-Day2.swift
//  AOC
//
//  Created by Micah Wilson on 12/4/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day2: Day {
        func calculateScoreOptimistic(_ line: String) -> Int {
            let input = line.spaces
            
            switch (input[0], input[1]) {
            case ("A", "X"):
                return 4
            case ("B", "X"):
                return 1
            case ("C", "X"):
                return 7
            case ("A", "Y"):
                return 8
            case ("B", "Y"):
                return 5
            case ("C", "Y"):
                return 2
            case ("A", "Z"):
                return 3
            case ("B", "Z"):
                return 9
            case ("C", "Z"):
                return 6
            default:
                return 0
            }
        }
        
        func calculateScoreDeterministic(_ line: String) -> Int {
            let input = line.spaces
            
            switch (input[0], input[1]) {
            case ("A", "X"):
                return 3
            case ("B", "X"):
                return 1
            case ("C", "X"):
                return 2
            case ("A", "Y"):
                return 4
            case ("B", "Y"):
                return 5
            case ("C", "Y"):
                return 6
            case ("A", "Z"):
                return 8
            case ("B", "Z"):
                return 9
            case ("C", "Z"):
                return 7
            default:
                return 0
            }
        }
        
        func part1() -> String {
            let rounds = input.lines
            let score = rounds.map(calculateScoreOptimistic(_:)).reduce(into: 0, +=)
            return "\(score)"
        }
        
        func part2() -> String {
            let rounds = input.lines
            let score = rounds.map(calculateScoreDeterministic(_:)).reduce(into: 0, +=)
            return "\(score)"
        }
    }
}
