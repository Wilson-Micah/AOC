//
//  2020-Day6.swift
//  AOC
//
//  Created by Micah Wilson on 12/19/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day6: Day {
        func part1() -> String {
            let groups = input.blankLines
            let sets = groups.map { Set(Array($0.replacingOccurrences(of: "\n", with: ""))) }
            let counts = sets.reduce(into: 0) { partialResult, groupSet in
                partialResult += groupSet.count
            }
            return "\(counts)"
        }
        
        func part2() -> String {
            let groups = input.blankLines
            let questionsAnswered = groups.map { group -> Int in
                let lines = group.lines
                var questionCount = [String.Element: Int]()
                for char in Array(group.replacingOccurrences(of: "\n", with: "")) {
                    questionCount[char, default: 0] += 1
                }
                return questionCount.values.filter { $0 == lines.count }.count
            }
            let count = questionsAnswered.reduce(into: 0) { partialResult, count in
                partialResult += count
            }
            return "\(count)"
        }
    }
}
