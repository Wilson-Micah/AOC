//
//  2022-Day13.swift
//  AOC
//
//  Created by Micah Wilson on 12/12/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day13: Day {
        func validInput(lhs: String, rhs: String) -> Bool? {
            var lhs = lhs
            var rhs = rhs
            
            if lhs.isEmpty && rhs.isEmpty {
                return nil
            } else if lhs.isEmpty && !rhs.isEmpty {
                return true
            } else if rhs.isEmpty && !lhs.isEmpty {
                return false
            } else if !lhs.starts(with: "[") && !rhs.starts(with: "[") {
                let lComponents = Int(lhs.commas[0])!
                let rComponents = Int(rhs.commas[0])!
                if lComponents < rComponents {
                    return true
                } else if rComponents < lComponents {
                    return false
                } else {
                    lhs = lhs.commas.dropFirst().joined(separator: ",")
                    rhs = rhs.commas.dropFirst().joined(separator: ",")
                    return validInput(lhs: lhs, rhs: rhs)
                }
            } else if lhs.starts(with: "[") && rhs.starts(with: "[") {
                var lSubstring = lhs.findBracket()
                var rSubstring = rhs.findBracket()
                lhs.removeFirst(lSubstring.count)
                rhs.removeFirst(rSubstring.count)
                lSubstring.removeBracket()
                rSubstring.removeBracket()
                
                if rhs.starts(with: ",") {
                    rhs.removeFirst()
                }
                if lhs.starts(with: ",") {
                    lhs.removeFirst()
                }
                
                if let valid = validInput(lhs: lSubstring, rhs: rSubstring) {
                   return valid
                } else {
                    return validInput(lhs: lhs, rhs: rhs)
                }
            } else if lhs.starts(with: "[") && !rhs.starts(with: "[") {
                var components = rhs.commas
                components[0] = "[\(components[0])]"
                return validInput(lhs: lhs, rhs: components.joined(separator: ","))
            } else {
                var components = lhs.commas
                components[0] = "[\(components[0])]"
                return validInput(lhs: components.joined(separator: ","), rhs: rhs)
            }
        }
        
        func part1() -> String {
            let input = input.blankLines
            
            var valid = [Int]()
            for pair in input.indexed() {
                let sides = pair.element.lines
                if validInput(lhs: sides[0], rhs: sides[1])! {
                    valid.append(pair.index + 1)
                }
            }
            
            return "\(valid.reduce(into: 0, +=))"
        }
        
        func part2() -> String {
            let dividers = ["[[2]]", "[[6]]"]
            var input = input.blankLines.flatMap { $0.lines }
            input.append(contentsOf: dividers)
            
            input.sort { lhs, rhs in
                validInput(lhs: lhs, rhs: rhs)!
            }
        
            let key = zip(input, 1...input.count).filter {
                dividers.contains($0.0)
            }
            .map(\.1)
            .reduce(into: 1, *=)

            return "\(key)"
        }
    }
}
