//
//  2020Day8.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day8: Day {
        struct Console {
            var accumulator = 0
            var line = 0
            var linesExecuted = Set<Int>()
            var code: [String]
            
            @discardableResult
            mutating func boot() -> Bool {
                line = 0
                accumulator =  0
                linesExecuted.removeAll()
                while linesExecuted.insert(line).inserted {
                    if line >= code.count {
                        return true
                    } else {
                        runLine(code[line])
                    }
                }
                return false
            }
            
            mutating func fixBootLoop() {
                while linesExecuted.insert(line).inserted {
                    runLine(code[line])
                }
            }
            
            mutating func runLine(_ input: String) {
                let components = input.spaces
                let command = components[0]
                let value = Int(components[1])!
                
                switch command {
                case "acc":
                    accumulator += value
                    line += 1
                case "jmp":
                    line += value
                default:
                    line += 1
                }
            }
        }
        func part1() -> String {
            var console = Console(code: input.lines)
            console.boot()
            return "\(console.accumulator)"
        }
        
        func part2() -> String {
            let lines = input.lines
            var console = Console(code: lines)
            var lineChange = 0
            while !console.boot() {
                console.code = lines
                console.code[lineChange] = lines[lineChange].contains("nop") ? lines[lineChange].replacingOccurrences(of: "nop", with: "jmp") : lines[lineChange].replacingOccurrences(of: "jmp", with: "nop")
                lineChange += 1
            }
            return "\(console.accumulator)"
        }
    }
}
