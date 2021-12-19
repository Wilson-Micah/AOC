//
//  Day11.swift
//  AOC21
//
//  Created by Micah Wilson on 12/9/21.
//

import Foundation

extension AOC21 {
    struct Day11: Day {
        func flashGrid(_ grid: inout [[Int]], col: Int, row: Int) {
            grid[col][row] += 1
            guard grid[col][row] == 10 else { return }
            var colOffsets = [0]
            var rowOffsets = [0]
            if col > 0 {
                colOffsets.append(-1)
            }
            if col + 1 < grid.count {
                colOffsets.append(1)
            }
            if row > 0 {
                rowOffsets.append(-1)
            }
            if row + 1 < grid[col].count {
                rowOffsets.append(1)
            }
            
            for colOffset in colOffsets {
                for rowOffset in rowOffsets {
                    flashGrid(&grid, col: col + colOffset, row: row + rowOffset)
                }
            }
        }
        
        func stepGrid(_ grid: inout [[Int]]) -> Int {
            var flashes = 0
            
            for col in grid.indices {
                for row in grid[col].indices {
                    flashGrid(&grid, col: col, row: row)
                }
            }
            
            for col in grid.indices {
                for row in grid[col].indices {
                    if grid[col][row] >= 10 {
                        flashes += 1
                        grid[col][row] = 0
                    }
                }
            }
            return flashes
        }
        
        func part1() -> String {
            var grid = input.gridNoSeparator
            
            var flashes = 0
            for _ in 0..<100 {
                flashes += stepGrid(&grid)
            }
            
            return "\(flashes)"
        }
        
        func part2() -> String {
            var grid = input.gridNoSeparator
            
            var step = 0
            repeat {
                step += 1
            } while stepGrid(&grid) != grid.count * grid[0].count
            
            return "\(step)"
        }
    }
}
