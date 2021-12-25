//
//  2021-Day24.swift
//  AOC
//
//  Created by Micah Wilson on 12/23/21.
//

import Algorithms
import Foundation

extension AOC21 {
    struct Day24: Day {
        struct ALU {
            var data = ["w": 0, "x": 0, "y": 0, "z": 0]
            
            mutating func process(line: String) -> Bool {
                let components = line.spaces
                let command = components[0]
                
                switch command {
                case "inp":
                    data[components[1]] = Int(components[2])!
                case "add":
                    data[components[1]] = data[components[1]]! + (data[components[2]] ?? Int(components[2])!)
                case "mul":
                    data[components[1]] = data[components[1]]! * (data[components[2]] ?? Int(components[2])!)
                case "div" where (data[components[2]] ?? Int(components[2])!) != 0:
                    data[components[1]] = data[components[1]]! / (data[components[2]] ?? Int(components[2])!)
                case "mod" where data[components[1]]! >= 0 && (data[components[2]] ?? Int(components[2])!) > 0:
                    data[components[1]] = data[components[1]]! % (data[components[2]] ?? Int(components[2])!)
                case "eql":
                    data[components[1]] = data[components[1]]! == (data[components[2]] ?? Int(components[2])!) ? 1 : 0
                default:
                    return false
                }
                return true
            }
        }
        
        var minAndMax: (String, String) {
            let instructions = Array(input.components(separatedBy: "inp w\n").map { $0.lines }.dropFirst())
            var minValue = Array(repeating: 0, count: 14)
            var maxValue = Array(repeating: 0, count: 14)
            var stack = [(Int, Int)]()
            
            for (var i, chunk) in Array(instructions).enumerated() {
                if chunk[3] == "div z 1" {
                    stack.append((i, Int(chunk[14].components(separatedBy: .whitespaces).last!)!))
                } else if chunk[3] == "div z 26" {
                    var (first, second) = stack.removeLast()
                    var diff = second + Int(chunk[4].components(separatedBy: .whitespaces).last!)!
                    if diff < 0 {
                       (i, first, diff) = (first, i, -diff)
                    }
                    
                    maxValue[i] = 9
                    maxValue[first] = 9 - diff
                    minValue[i] = 1 + diff
                    minValue[first] = 1
                }
            }
            
            return (minValue.map(String.init).joined(), maxValue.map(String.init).joined())
        }
        
        func validateID(input: [String], lines: [String]) -> Bool {
            var input = input
            var alu = ALU()
            
            for line in lines {
                if line.contains("inp") {
                    if !alu.process(line: line + " \(input.removeFirst())") {
                        return false
                    }
                } else {
                    if !alu.process(line: line) {
                        return false
                    }
                }
            }
            return alu.data["z"] == 0
        }
        
        // This couldn't be solved without actually looking through the alu program and finding the pattern by hand that linked different digits together. I'm not that interested in parsing the input by hand to find out my solution so this solution is influenced by users on reddit.
        func part1() -> String {
            let lines = input.lines
            let (_, maxValue) = minAndMax
            
            if validateID(input: Array("\(maxValue)").map(String.init), lines: lines) {
                return maxValue
            } else {
                return ""
            }
        }
        
        func part2() -> String {
            let lines = input.lines
            let (minValue, _) = minAndMax
            
            if validateID(input: Array("\(minValue)").map(String.init), lines: lines) {
                return minValue
            } else {
                return ""
            }
        }
    }
}
