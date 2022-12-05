//
//  2022-Day5.swift
//  AOC
//
//  Created by Micah Wilson on 12/5/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day5: Day {
        func stackCrates(reversed: Bool) -> String {
            let data = input.blankLines
            var state = data[0].columnsWithCommonDelimiter.map {
                Array($0.dropLast())
            }
            
            let instructions = data[1].lines.map {
                let data = $0.spaces
                return [Int(data[1])!, Int(data[3])!, Int(data[5])!]
            }
            
            for instruction in instructions {
                let toMove = state[instruction[1] - 1][0..<instruction[0]]
                state[instruction[1] - 1] = Array(state[instruction[1] - 1].dropFirst(instruction[0]))
                state[instruction[2] - 1].insert(contentsOf: reversed ? Array(toMove.reversed()) : Array(toMove), at: 0)
            }
            
            let code = state.reduce(into: "") { partialResult, column in
                partialResult += column.first ?? ""
            }
            return "\(code.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: ""))"
        }
        
        func part1() -> String {
            stackCrates(reversed: true)
        }
        
        func part2() -> String {
            stackCrates(reversed: false)
        }
    }
}

