//
//  Day12.swift
//  AOC21
//
//  Created by Micah Wilson on 12/11/21.
//

import Foundation

struct Day12: Day {
    enum DuplicationStrategy {
        case notAllowed
        case limitReached
        case limitNotReached
    }
    
    var cave: [String: Set<String>] {
        input.lines.reduce(into: [String: Set<String>]()) { result, line in
            let components = line.components(separatedBy: "-")
            result[components[0], default: []].insert(components[1])
            if components[1] != "end" && components[0] != "start" {
                result[components[1], default: []].insert(components[0])
            }
        }
    }
    
    func pathCount(
        cave: [String: Set<String>],
        position: String = "start",
        visited: Set<String> = [],
        duplicationStrategy: DuplicationStrategy
    ) -> Int {
        var duplicationStrategy = duplicationStrategy
        var visited = visited
        if position == "end" {
            return 1
        } else if position.allSatisfy(\.isLowercase) && visited.contains(position) {
            if duplicationStrategy == .limitNotReached {
                duplicationStrategy = .limitReached
            } else {
                return 0
            }
        }
        
        visited.insert(position)
        var count = 0
        for pos in cave[position] ?? [] {
            count += pathCount(
                cave: cave,
                position: pos,
                visited: visited,
                duplicationStrategy: duplicationStrategy
            )
        }
        return count
    }
    
    func part1() -> String {
        let count = pathCount(
            cave: cave,
            duplicationStrategy: .notAllowed
        )
        return "\(count)"
    }
    
    func part2() -> String {
        let count = pathCount(
            cave: cave,
            duplicationStrategy: .limitNotReached
        )
        return "\(count)"
    }
}
