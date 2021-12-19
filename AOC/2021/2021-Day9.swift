//
//  Day9.swift
//  AOC21
//
//  Created by Micah Wilson on 12/8/21.
//

import Foundation

extension AOC21 {
    struct Day9: Day {
        func basins(input: [[Int]]) -> [Point] {
            var basins = [Point]()
            for col in input.indices {
                for row in input[col].indices {
                    let above = col > 0 ? input[col - 1][row] : 9
                    let below = col < input.count - 1 ? input[col + 1][row] : 9
                    let left = row > 0 ? input[col][row - 1] : 9
                    let right = row < input[col].count - 1 ? input[col][row + 1] : 9
                    let value = input[col][row]
                    
                    if value < above && value < below && value < left && value < right {
                        basins.append(.init(x: col, y: row))
                    }
                }
            }
            
            return basins
        }
        
        func part1() -> String {
            let input = input.columns.map { $0.ints }
            let basins = basins(input: input)
            
            let risk = basins.reduce(into: 0) { partialResult, point in
                partialResult += input[point.x][point.y] + 1
            }
            
            return "\(risk)"
        }
        
        func part2() -> String {
            let input = input.columns.map { $0.ints }
            let basins = basins(input: input)
            
            let basinSizes = basins.map { basin -> Int in
                var size = 0
                var checkedInput = input
                var col = basin.x
                var row = basin.y
                
                var checks = Set([Point(x: col, y: row)])
                while !checks.isEmpty {
                    if let first = checks.first {
                        col = first.x
                        row = first.y
                        checks.removeFirst()
                    }
                    
                    checkedInput[col][row] = 9
                    size += 1
                    
                    let above: Int = col > 0 ? checkedInput[col - 1][row] : 9
                    let below: Int = col < checkedInput.count - 1 ? checkedInput[col + 1][row] : 9
                    let left: Int = row > 0 ? checkedInput[col][row - 1] : 9
                    let right: Int = row < checkedInput[col].count - 1 ? checkedInput[col][row + 1] : 9
                    
                    if above != 9 {
                        checks.insert(.init(x: col - 1, y: row))
                    }
                    if below != 9 {
                        checks.insert(.init(x: col + 1, y: row))
                    }
                    if left != 9 {
                        checks.insert(.init(x: col, y: row - 1))
                    }
                    if right != 9 {
                        checks.insert(.init(x: col, y: row + 1))
                    }
                }
                
                return size
            }
            
            return "\(basinSizes.max(count: 3).reduce(1, *))"
        }
    }
}
