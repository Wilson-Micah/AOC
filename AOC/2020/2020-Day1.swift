//
//  Day1.swift
//  AOC
//
//  Created by Micah Wilson on 12/17/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day1: Day {
        func part1() -> String {
            let input = Set(input.lines.ints)
            guard let result = input.first(where: { input.contains(2020 - $0) }) else { return "" }
            return "\((2020 - result) * result)"
        }
        
        func part2() -> String {
            let input = input.lines.ints
            let combos = input.sorted(by: <).combinations(ofCount: 2)
            guard let combo = combos.first(where: { input.contains(2020 - $0.reduce(into: 0, +=)) }) else { return "" }
            let leftoverValue = 2020 - combo.reduce(into: 0, +=)
            let result = ([leftoverValue] + combo).reduce(into: 1, *=)
            return "\(result)"
        }
    }
}
