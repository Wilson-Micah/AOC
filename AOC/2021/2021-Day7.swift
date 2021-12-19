//
//  Day7.swift
//  AOC21
//
//  Created by Micah Wilson on 12/6/21.
//

import Foundation

extension AOC21 {
    struct Day7: Day {
        func part1() -> String {
            let input = input.commas.ints.sorted()
            let median = input[input.count / 2]
            
            let fuelUsed = input.reduce(into: 0) { partialResult, value in
                partialResult += abs(value - median)
            }
            return "\(fuelUsed)"
        }
        
        func part2() -> String {
            let input = input.commas.ints.sorted()
            let mean = Double(input.reduce(0, +)) / Double(input.count)
            let attempts = [Int(floor(mean)), Int(ceil(mean))]
            
            let results = attempts.map { mean in
                input.reduce(into: 0) { partialResult, value in
                    let diff = abs(value - Int(mean))
                    partialResult += diff.triangleNumber
                }
            }
            
            return "\(results.min()!)"
        }
    }
}
