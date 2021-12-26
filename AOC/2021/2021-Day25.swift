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
        func move(right: Bool, positions: inout Set<Point>, grid: inout [[String]]) {
            let query = right ? ">" : "v"
            let originalGrid = grid
            for point in positions {
                let newPoint = right ? Point(x: (point.x + 1) % originalGrid.count, y: point.y % originalGrid[point.x].count) : Point(x: point.x % originalGrid.count, y: (point.y + 1) % originalGrid[point.x].count)
                if originalGrid[point.x][point.y] == query && originalGrid[newPoint.x][newPoint.y] == "." {
                    grid[newPoint.x][newPoint.y] = originalGrid[point.x][point.y]
                    grid[point.x][point.y] = "."
                    
                    positions.remove(point)
                    positions.insert(newPoint)
                }
            }
        }
        
        func move(rightPositions: inout Set<Point>, downPositions: inout Set<Point>, grid: [[String]]) -> [[String]] {
            var grid = grid
            move(right: true, positions: &rightPositions, grid: &grid)
            move(right: false, positions: &downPositions, grid: &grid)
            return grid
        }
        
        func part1() -> String {
            var input = input.columns
            var transitions = 0
            var rightPositions = Set<Point>()
            var downPositions = Set<Point>()
            
            input.traverse { point in
                if input[point.x][point.y] == ">" {
                    rightPositions.insert(point)
                } else if input[point.x][point.y] == "v" {
                    downPositions.insert(point)
                }
            }
            
            
            while true {
                let transition = move(rightPositions: &rightPositions, downPositions: &downPositions, grid: input)
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
