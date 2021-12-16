//
//  Day15.swift
//  AOC21
//
//  Created by Micah Wilson on 12/13/21.
//

import Algorithms
import Foundation

struct Day15: Day {
    func part1() -> String {
        let grid = input.gridNoSeparator
        let end = Point(x: grid.count - 1, y: grid.count - 1)
        return "\(grid.shortestPath(start: .init(x: 0, y: 0), end: end))"
    }
    
    func part2() -> String {
        let grid = input.gridNoSeparator
        var largeGrid = [[Int]]()
        for x in 0..<5 {
            for y in 0..<5 {
                for gridX in grid.indices {
                    if x == 0 {
                        largeGrid.append([])
                    }
                    for gridY in grid.indices {
                        largeGrid[gridX + x * grid.count].append(((grid[gridX][gridY] + x + y) - 1) % 9 + 1)
                    }
                }
            }
        }
        
        let end = Point(x: largeGrid.count - 1, y: largeGrid.count - 1)
        return "\(largeGrid.shortestPath(start: .init(x: 0, y: 0), end: end))"
    }
}
