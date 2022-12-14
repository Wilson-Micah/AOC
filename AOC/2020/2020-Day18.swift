//
//  2020-Day18.swift
//  AOC
//
//  Created by Micah Wilson on 12/13/22.
//

import Algorithms
import Foundation

extension String {
    mutating func popNextEquationPiece() -> String? {
        let components = spaces.filter({ !$0.isEmpty })
        if components.joined(separator: " ").starts(with: "(") {
            var paren = self.findParens()
            self.removeFirst(paren.count)
            if self.starts(with: " ") {
                self.removeFirst()
            }
            paren.removeFirst()
            paren.removeLast()
            return paren
        } else if let number = Int(components[0]) {
            self = components.dropFirst().joined(separator: " ")
            return "\(number)"
        } else {
            self = components.dropFirst().joined(separator: " ")
            return components[0]
        }
    }
}

extension AOC20 {
    struct Day18: Day {
        func evaluateEquation(prioritizeAdd: Bool = false, equation: inout String) -> Int {
            var value = 0
            var operation = "+"
            while !equation.isEmpty {
                let next = equation.popNextEquationPiece()
                
                guard var next = next, !next.isEmpty else {
                    return value
                }
                
                if next == "+" || next == "*" {
                    operation = next
                    continue
                }
                let number = Int(next) ?? evaluateEquation(prioritizeAdd: prioritizeAdd, equation: &next)
                if operation == "*" {
                    if prioritizeAdd {
                        equation = "\(number) \(equation)"
                        value *= evaluateEquation(prioritizeAdd: prioritizeAdd, equation: &equation)
                    } else {
                        value *= number
                    }
                } else {
                    value += number
                }
            }
            return value
        }
        
        func part1() -> String {
            let data = input.lines
            let results = data.map { line in
                var line = line
                return evaluateEquation(equation: &line)
            }
            return "\(results.reduce(into: 0, +=))"
        }
        
        func part2() -> String {
            let data = input.lines
            let results = data.compactMap { line in
                var line = line
                return evaluateEquation(prioritizeAdd: true, equation: &line)
            }
            return "\(results.reduce(into: 0, +=))"
        }
    }
}
