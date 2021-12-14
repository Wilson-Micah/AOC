//
//  Day14.swift
//  AOC21
//
//  Created by Micah Wilson on 12/12/21.
//

import Algorithms
import Foundation

struct Day14: Day {
    func runPolymer(_ polymer: String, map: [String: String], iterations: Int) -> Int {
        var pairs = [String: Int]()
        for pair in Array(polymer).map(String.init).windows(ofCount: 2) {
            pairs[pair.joined(), default: 0] += 1
        }
        
        for _ in 0..<iterations {
            var tempPairs = [String: Int]()
            for (pair, count) in pairs {
                let first = String(pair.first!)
                let last = String(pair.last!)
                let middle = map[pair]!
                tempPairs[first + middle, default: 0] += count
                tempPairs[middle + last, default: 0] += count
            }
            pairs = tempPairs
        }
        
        let charCount = pairs.reduce(into: [polymer.last!: 1]) { partialResult, map in
            partialResult[map.key.first!, default: 0] += map.value
        }
        let (min, max) = charCount.values.minAndMax()!
        return max - min
    }
    
    func parseAndRun(count: Int) -> String {
        let input = input.components(separatedBy: "\n\n")
        let polymer = input[0]
        var map = [String: String]()
        input[1].lines.forEach { line in
            let components = line.components(separatedBy: " -> ")
            map[components[0]] = components[1]
        }
        
        let answer = runPolymer(polymer, map: map, iterations: count)
        
        return "\(answer)"
    }
    
    func part1() -> String {
        parseAndRun(count: 10)
    }
    
    func part2() -> String {
        parseAndRun(count: 40)
    }
}
