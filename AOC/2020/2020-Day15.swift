//
//  2020-Day15.swift
//  AOC
//
//  Created by Micah Wilson on 12/8/22.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day15: Day {
        func findNumber(index: Int) -> String {
            var recentNumbers = [Int: Int]()
            let input = input.commas.ints
            input.enumerated().forEach { recentNumbers[$0.element] = $0.offset + 1 }
            var lastNumber = input.last!
            var lastIndex = recentNumbers[lastNumber]
            for i in input.count..<(index) {
                if let index = lastIndex {
                    lastNumber = i - index
                    lastIndex = recentNumbers[lastNumber]
                    recentNumbers[lastNumber] = i + 1
                } else {
                    lastNumber = 0
                    lastIndex = recentNumbers[lastNumber]
                    recentNumbers[0] = i + 1
                }
            }
            return "\(lastNumber)"
        }
        
        func part1() -> String {
            findNumber(index: 2020)
        }
        
        func part2() -> String {
            findNumber(index: 30000000)
        }
    }
}
