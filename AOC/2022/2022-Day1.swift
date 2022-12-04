//
//  2022-Day1.swift
//  AOC
//
//  Created by Micah Wilson on 12/1/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day1: Day {
        func part1() -> String {
            let elves = input.blankLines.map { elf in elf.lines.ints.reduce(into: 0, +=) }
            return "\(elves.max()!)"
        }
        
        func part2() -> String {
            let top3 = input.blankLines
                .map { elf in elf.lines.ints.reduce(into: 0, +=) }
                .sorted(by: >)
                .prefix(3)
                .reduce(into: 0, +=)
            return "\(top3)"
        }
    }
}
