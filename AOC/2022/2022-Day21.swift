//
//  2022-Day21.swift
//  AOC
//
//  Created by Micah Wilson on 12/21/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day21: Day {
        func solve(monkeys: [String: String], current: String) -> Int {
            guard let problem = monkeys[current] else { return -1 }
            let components = problem.spaces
            
            if components.count == 3 {
                let lhsValue = Int(components[0]) ?? solve(monkeys: monkeys, current: components[0])
                let rhsValue = Int(components[2]) ?? solve(monkeys: monkeys, current: components[2])
                switch components[1] {
                case "+":
                    return lhsValue + rhsValue
                case "-":
                    return lhsValue - rhsValue
                case "*":
                    return lhsValue * rhsValue
                case "/":
                    return lhsValue / rhsValue
                default:
                    fatalError()
                }
            } else {
                return Int(components[0])!
            }
        }
        
        func solveForX(lhs: String, rhs: Int) -> Int {
            if lhs == "x" {
                return rhs
            } else {
                var lhs = lhs
                lhs.removeParen()
                var left: String
                if lhs.starts(with: "(") {
                    left = lhs.findParens()
                    lhs = String(lhs.dropFirst(left.count))
                } else {
                    left = lhs.spaces[0]
                    lhs = " " + lhs.spaces.dropFirst().joined(separator: " ")
                }
                
                let operan = String(lhs[lhs.startIndex..<lhs.index(lhs.startIndex, offsetBy: 3)]).spaces[1]
                lhs.removeFirst(3)
                let right = Int(lhs) != nil ? "\(lhs)" : lhs.findParens()
                
                if left.contains("x") {
                    let solution = NSExpression(format: right).expressionValue(with: nil, context: nil) as! Int
                    switch operan {
                    case "+":
                        return solveForX(lhs: left, rhs: rhs - solution)
                    case "-":
                        return solveForX(lhs: left, rhs: rhs + solution)
                    case "*":
                        return solveForX(lhs: left, rhs: rhs / solution)
                    case "/":
                        return solveForX(lhs: left, rhs: rhs * solution)
                    default:
                        fatalError()
                    }
                } else {
                    let solution = NSExpression(format: left).expressionValue(with: nil, context: nil) as! Int
                    switch operan {
                    case "+":
                        return solveForX(lhs: right, rhs: rhs - solution)
                    case "-":
                        return solveForX(lhs: right, rhs: -(rhs - solution))
                    case "*":
                        return solveForX(lhs: right, rhs: rhs / solution)
                    case "/":
                        return solveForX(lhs: right, rhs: solution / rhs)
                    default:
                        fatalError()
                    }
                }
            }
        }
        
        func collapse(monkeys: [String: String], current: String) -> String {
            guard let problem = monkeys[current] else { return "" }
            let components = problem.spaces
            
            if current == "humn" {
                return "x"
            }
            if components.count == 3 {
                let lhsValue = Int(components[0]) != nil ? components[0] : collapse(monkeys: monkeys, current: components[0])
                let rhsValue = Int(components[2]) != nil ? components[2] : collapse(monkeys: monkeys, current: components[2])
                
                if current == "root" {
                    return "\(lhsValue) = \(rhsValue)"
                } else {
                    switch components[1] {
                    case "+":
                        return "(\(lhsValue) + \(rhsValue))"
                    case "-":
                        return "(\(lhsValue) - \(rhsValue))"
                    case "*":
                        return "(\(lhsValue) * \(rhsValue))"
                    case "/":
                        return "(\(lhsValue) / \(rhsValue))"
                    default:
                        fatalError()
                    }
                }
            } else {
                return components[0]
            }
        }
        
        func part1() -> String {
            let data = input.lines.reduce(into: [String: String]()) { partialResult, line in
                let components = line.components(separatedBy: ": ")
                partialResult[components[0]] = components[1]
            }
            return "\(solve(monkeys: data, current: "root"))"
        }
        
        func part2() -> String {
            let data = input.lines.reduce(into: [String: String]()) { partialResult, line in
                let components = line.components(separatedBy: ": ")
                partialResult[components[0]] = components[1]
            }
            
            let equation = collapse(monkeys: data, current: "root")
            let components = equation.components(separatedBy: " = ")
            let rhs = NSExpression(format: components[1]).expressionValue(with: nil, context: nil) as! Int

            return "\(solveForX(lhs: components[0], rhs: rhs))"
        }
    }
}
