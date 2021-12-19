//
//  Day1.swift
//  AOC21
//
//  Created by Micah Wilson on 12/3/21.
//

import Foundation

extension AOC21 {
    struct Day1: Day {
        func part1() -> String {
            let input = input.lines.ints
            var current = Int.max
            var increases = 0
            for step in input {
                if step > current {
                    increases += 1
                }
                current = step
            }
            
            return "\(increases)"
        }
        
        func part2() -> String {
            let input = input.lines.ints
            let result = input.indices.dropFirst(3).reduce(into: 0) { partialResult, step in
                partialResult += input[step] > input[step - 3] ? 1 : 0
            }
            
            return "\(result)"
        }
    }
}
