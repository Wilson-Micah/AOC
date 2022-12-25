//
//  2022-Day24.swift
//  AOC
//
//  Created by Micah Wilson on 12/24/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day24: Day {
        struct Blizzard: Hashable {
            var position: Point
            let direction: Direction
        }
        
        static var grids = [Int: ([[String]], [Blizzard])]()
        
        static func grid(for time: Int) -> ([[String]], [Blizzard]) {
            if let grid = grids[time] {
                return grid
            } else {
                let startGrid = grids[0]!
                var modifiedGrid = startGrid.0
                let gridWidth = startGrid.0[0].count - 2
                let gridHeight = startGrid.0.count - 2
                var newPositions = [Blizzard]()
                for var blizzard in startGrid.1 {
                    modifiedGrid[blizzard.position.y + 1][blizzard.position.x + 1] = "."
                    switch blizzard.direction {
                    case .west:
                        blizzard.position.x -= time
                        blizzard.position.x %= gridWidth
                        if blizzard.position.x < 0 {
                            blizzard.position.x += gridWidth
                        }
                    case .east:
                        blizzard.position.x += time
                        blizzard.position.x %= gridWidth
                    case .north:
                        blizzard.position.y -= time
                        blizzard.position.y %= gridHeight
                        if blizzard.position.y < 0 {
                            blizzard.position.y += gridHeight
                        }
                    case .south:
                        blizzard.position.y += time
                        blizzard.position.y %= gridHeight
                    default: break
                    }
                    newPositions.append(blizzard)
                }
                
                for blizzard in newPositions {
                    modifiedGrid[blizzard.position.y + 1][blizzard.position.x + 1] = "#"
                }
                grids[time] = (modifiedGrid, newPositions)
                return (modifiedGrid, newPositions)
            }
        }
        
        struct Position: Hashable {
            let position: Point
            let grid: [[String]]
            let blizzards: [Blizzard]
        }
        
        func shortestPath(start: Point, end: Point) -> Int {
//            var seen = Set<Point>()
            var queue = Heap(array: [(start, 0)], sort: { ($0.1 + $0.0.manhattenTo(point: end)) < ($1.1 + $1.0.manhattenTo(point: end)) })
            var count = 0
            var seen = Set<Position>()
            while !queue.isEmpty {
                count += 1
                let (pos, distance) = queue.peek()!
                queue.remove()
                if end == pos {
                    return distance
                }
                
                let next = Self.grid(for: distance + 1)
                
                var visited = Position(
                    position: pos,
                    grid: next.0,
                    blizzards: next.1
                )
                
                if seen.contains(visited) {
                    continue
                }
                
                seen.insert(visited)
                
                let nextGrid = next.0
                
                if pos.y < nextGrid.count - 1 && nextGrid[pos.y + 1][pos.x] == "." {
                    queue.insert((Point(x: pos.x, y: pos.y + 1), distance + 1))
                }
                
                if pos.y > 0 && nextGrid[pos.y - 1][pos.x] == "." {
                    queue.insert((Point(x: pos.x, y: pos.y - 1), distance + 1))
                }
                
                if nextGrid[pos.y][pos.x + 1] == "." {
                    queue.insert((Point(x: pos.x + 1, y: pos.y), distance + 1))
                }
                
                if pos.x > 0 && nextGrid[pos.y][pos.x - 1] == "." {
                    queue.insert((Point(x: pos.x - 1, y: pos.y), distance + 1))
                }
                
                if nextGrid[pos.y][pos.x] == "." {
                    queue.insert((Point(x: pos.x, y: pos.y), distance + 1))
                }
            }
            
            return -1
        }
        
        func part1() -> String {
            let grid = input.gridNoSeparatorStrings
            var blizzards = [Blizzard]()
            grid.traverse { point in
                if grid[point.x][point.y] == "<" {
                    blizzards.append(.init(position: .init(x: point.y - 1, y: point.x - 1), direction: .west))
                } else if grid[point.x][point.y] == "^" {
                    blizzards.append(.init(position: .init(x: point.y - 1, y: point.x - 1), direction: .north))
                } else if grid[point.x][point.y] == "v" {
                    blizzards.append(.init(position: .init(x: point.y - 1, y: point.x - 1), direction: .south))
                } else if grid[point.x][point.y] == ">" {
                    blizzards.append(.init(position: .init(x: point.y - 1, y: point.x - 1), direction: .east))
                }
            }
            Self.grids[0] = (grid, blizzards)
            
            return "\(shortestPath(start: .init(x: 1, y: 0), end: .init(x: grid[0].count - 2, y: grid.count - 1)))"
        }
        
        func part2() -> String {
            let grid = input.gridNoSeparatorStrings
            var blizzards = [Blizzard]()
            grid.traverse { point in
                if grid[point.x][point.y] == "<" {
                    blizzards.append(.init(position: .init(x: point.y - 1, y: point.x - 1), direction: .west))
                } else if grid[point.x][point.y] == "^" {
                    blizzards.append(.init(position: .init(x: point.y - 1, y: point.x - 1), direction: .north))
                } else if grid[point.x][point.y] == "v" {
                    blizzards.append(.init(position: .init(x: point.y - 1, y: point.x - 1), direction: .south))
                } else if grid[point.x][point.y] == ">" {
                    blizzards.append(.init(position: .init(x: point.y - 1, y: point.x - 1), direction: .east))
                }
            }
            Self.grids[0] = (grid, blizzards)
            
            var to = shortestPath(start: .init(x: 1, y: 0), end: .init(x: grid[0].count - 2, y: grid.count - 1))
            var startPositions = Self.grid(for: to)
            Self.grids.removeAll()
            Self.grids[0] = startPositions
            var back = shortestPath(start: .init(x: grid[0].count - 2, y: grid.count - 1), end: .init(x: 1, y: 0))
            startPositions = Self.grid(for: back)
            Self.grids.removeAll()
            Self.grids[0] = startPositions
            var final = shortestPath(start: .init(x: 1, y: 0), end: .init(x: grid[0].count - 2, y: grid.count - 1))
            return "\(to + back + final)"
        }
    }
}
