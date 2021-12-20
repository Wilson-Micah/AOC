//
//  2020-Day10.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day10: Day {
        func part1() -> String {
            let jolts = input.lines.ints
            let orderedJolts = [0] + jolts.sorted() + [jolts.max()! + 3]
            var jumps = [Int: Int]()
            for i in 1..<orderedJolts.count {
                jumps[orderedJolts[i] - orderedJolts[i - 1], default: 0] += 1
            }
            return "\(jumps[1]! * jumps[3]!)"
        }
        
        func part2() -> String {
            let jolts = input.lines.ints
            let orderedJolts = [0] + jolts.sorted() + [jolts.max()! + 3]
            let joltsSet = Set(orderedJolts)
            var pathCounts = [0: 1]
            for index in 0..<orderedJolts.count {
                let val = orderedJolts[index]
                let options = [val + 1, val + 2, val + 3]
                options.forEach {
                    guard joltsSet.contains($0) else { return }
                    pathCounts[$0, default: 0] += pathCounts[val]!
                }
            }
            
            let pathCount = pathCounts.values.max()!
            
            return "\(pathCount)"
        }
    }
}
