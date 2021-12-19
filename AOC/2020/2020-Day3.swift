//
//  2020-Day3.swift
//  AOC
//
//  Created by Micah Wilson on 12/18/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day3: Day {
        func treesEncountered(grid: [[String]], slope: Point) -> Int {
            var pos = Point(x: 0, y: 0)
            var treesHit = 0
            while pos.y < grid[0].count {
                if grid[pos.x % grid.count][pos.y] == "#" {
                    treesHit += 1
                }
                
                pos.x += slope.x
                pos.y += slope.y
            }
            return treesHit
        }
        
        func part1() -> String {
            let grid = input.columns
            return "\(treesEncountered(grid: grid, slope: .init(x: 3, y: 1)))"
        }
        
        func part2() -> String {
            let grid = input.columns
            let slopes = [
                Point(x: 1, y: 1),
                Point(x: 3, y: 1),
                Point(x: 5, y: 1),
                Point(x: 7, y: 1),
                Point(x: 1, y: 2)
            ]
            
            let result = slopes.reduce(into: 1) { partialResult, slope in
                partialResult *= treesEncountered(grid: grid, slope: slope)
            }
            return "\(result)"
        }
    }
}
