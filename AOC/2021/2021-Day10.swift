//
//  Day10.swift
//  AOC21
//
//  Created by Micah Wilson on 12/9/21.
//

import Foundation

extension AOC21 {
    struct Day10: Day {
        func part1() -> String {
            let input = input.lines
            var invalidCharacters = [String.Element]()
            for line in input {
                var stack = [String.Element]()
                for char in Array(line) {
                    if char.isOpenBracket {
                        stack.append(char)
                    } else if stack.popLast()?.closingBacket != char {
                        invalidCharacters.append(char)
                        break
                    }
                }
            }
            let score = invalidCharacters.reduce(into: 0) { partialResult, character in
                switch character {
                case ")":
                    partialResult += 3
                case "]":
                    partialResult += 57
                case "}":
                    partialResult += 1197
                case ">":
                    partialResult += 25137
                default:
                    partialResult += 0
                }
            }
            return "\(score)"
        }
        
        func part2() -> String {
            let input = input.lines
            var completions = [[String.Element]]()
            
        outer: for line in input {
            var stack = [String.Element]()
            for char in Array(line) {
                if char.isOpenBracket {
                    stack.append(char)
                } else if stack.popLast()?.closingBacket != char {
                    continue outer
                }
            }
            
            var completion = [String.Element]()
            for char in stack.reversed() {
                completion.append(char.closingBacket)
            }
            completions.append(completion)
        }
            
            let scores = completions.map { completion in
                completion.reduce(into: 0) { partialResult, character in
                    partialResult *= 5
                    switch character {
                    case ")":
                        partialResult += 1
                    case "]":
                        partialResult += 2
                    case "}":
                        partialResult += 3
                    case ">":
                        partialResult += 4
                    default:
                        partialResult += 0
                    }
                }
            }
                .sorted()
            
            return "\(scores[scores.count/2])"
        }
    }
}
