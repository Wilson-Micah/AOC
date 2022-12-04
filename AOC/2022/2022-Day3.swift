//
//  2022-Day3.swift
//  AOC
//
//  Created by Micah Wilson on 12/4/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day3: Day {
        var values: [String: Int] = {
            var map = [String: Int]()
            var value = 0
            for c in UnicodeScalar("a").value...UnicodeScalar("z").value {
                value += 1
                map[String(UnicodeScalar(c)!)] = value
            }
            for c in UnicodeScalar("A").value...UnicodeScalar("Z").value {
                value += 1
                map[String(UnicodeScalar(c)!)] = value
            }
            
            return map
        }()
        
        func part1() -> String {
            let rucksacks = input.lines
                .reduce(into: 0) { partialResult, rucksack in
                    let size = rucksack.count
                    let components = Array(rucksack)
                    let compartment1 = Set(components[0..<(size / 2)])
                    let compartment2 = Set(components[(size / 2)..<size])
                    let common = compartment1.intersection(compartment2).first!
                    partialResult += values[String(common)]!
                }
            return "\(rucksacks)"
        }
        
        func part2() -> String {
            let score = input.lines
                .chunks(ofCount: 3)
                .map { rucksacks in
                    let common = rucksacks.reduce(into: Set(Array(rucksacks.first!)), { partialResult, ruck in
                        partialResult = partialResult.intersection(Set(Array(ruck)))
                    }).first!
                    return values[String(common)]!
                }
                .reduce(into: 0, +=)
            return "\(score)"
        }
    }
}
