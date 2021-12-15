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
        return "\(dijkstras(grid: grid, start: .init(x: 0, y: 0), end: end))"
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
        return "\(dijkstras(grid: largeGrid, start: .init(x: 0, y: 0), end: end))"
    }
}

extension Day {
    func dijkstras(grid: [[Int]], start: Point, end: Point) -> Int {
        var seen = Set<Point>()
        var queue = Heap(array: [(start, 0)], sort: { $0.1 < $1.1 })
        var count = 0
        while !queue.isEmpty {
            count += 1
            let (pos, distance) = queue.peek()!
            queue.remove()
            if pos == end {
                return distance
            }
            
            if seen.contains(pos) {
                continue
            }
            
            seen.insert(pos)
            
            if pos.x > 0 {
                queue.insert((Point(x: pos.x - 1, y: pos.y), distance + grid[pos.x - 1][pos.y]))
            }
            if pos.y > 0 {
                queue.insert((Point(x: pos.x, y: pos.y - 1), distance + grid[pos.x][pos.y - 1]))
            }
            
            if pos.x < grid.count - 1 {
                queue.insert((Point(x: pos.x + 1, y: pos.y), distance + grid[pos.x + 1][pos.y]))
            }
            
            if pos.y < grid.count - 1 {
                queue.insert((Point(x: pos.x, y: pos.y + 1), distance + grid[pos.x][pos.y + 1]))
            }
        }
        
        return 0
    }
}
