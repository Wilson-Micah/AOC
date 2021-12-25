//
//  2021-Day25.swift
//  AOC
//
//  Created by Micah Wilson on 12/24/21.
//

import Algorithms
import Foundation

extension AOC21 {
    struct Day25: Day {
        func move(right: Bool, grid: inout [[String]]) {
            let query = right ? ">" : "v"
            let originalGrid = grid
            originalGrid.traverse { point in
                let newPoint = right ? Point(x: (point.x + 1) % originalGrid.count, y: point.y % originalGrid[point.x].count) : Point(x: point.x % originalGrid.count, y: (point.y + 1) % originalGrid[point.x].count)
                if originalGrid[point.x][point.y] == query && originalGrid[newPoint.x][newPoint.y] == "." {
                    grid[newPoint.x][newPoint.y] = originalGrid[point.x][point.y]
                    grid[point.x][point.y] = "."
                }
            }
        }
        
        func move(grid: [[String]]) -> [[String]] {
            var grid = grid
            move(right: true, grid: &grid)
            move(right: false, grid: &grid)
            
            return grid
        }
        
        func part1() -> String {
            var input = input.columns
            var transitions = 0
            
            while true {
                let transition = move(grid: input)
                transitions += 1
                
                if transition == input {
                    return "\(transitions)"
                }
                input = transition
            }
        }
        
        func part2() -> String {
            return "No part 2 on Christmas"
        }
    }
}
