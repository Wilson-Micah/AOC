//
//  2022-Day22.swift
//  AOC
//
//  Created by Micah Wilson on 12/22/22.
//

import Algorithms
import Foundation

private extension Direction {
    var facing: Int {
        switch self {
        case .east:
            return 0
        case .south:
            return 1
        case .west:
            return 2
        case .north:
            return 3
        default:
            return 0
        }
    }
}

extension AOC22 {
    struct Day22: Day {
        func currentFace(grid: [[String]], pos: Point) -> Int {
            let x = pos.x / 50
            let y = pos.y / 50
            
            return Int([["", "1", "2"], ["", "3", ""], ["4", "5", ""], ["6", "", ""]][y][x])!
        }
        
        func convert(grid: [[String]], pos: Point, direction: Direction) -> (Point, Direction) {
            let currentFace = currentFace(grid: grid, pos: pos)
            let x = pos.x % 50
            let y = pos.y % 50
            switch direction {
            case .east:
                switch currentFace {
                case 1: break
                case 2:
                    // Move to 5
                    return (Point(x: 99, y: 149 - y), .west)
                case 3:
                    // Move to 2
                    return (Point(x: 100 + y, y: 49), .north)
                case 4: break
                case 5:
                    // Move to 2
                    return (Point(x: 149, y: 49 - y), .west)
                case 6:
                    // Move to 5
                    return (Point(x: 50 + y, y: 149), .north)
                default: break
                }
            case .west:
                switch currentFace {
                case 1:
                    // Move to 4
                    return (Point(x: 0, y: 149 - y), .east)
                case 2: break
                case 3:
                    // Move to 4
                    return (Point(x: y, y: 100), .south)
                case 4:
                    // Move to 1
                    return (Point(x: 50, y: 49 - y), .east)
                case 5: break
                case 6:
                    // Move to 1
                    return (Point(x: 50 + y, y: 0), .south)
                default: break
                }
            case .north:
                switch currentFace {
                case 1:
                    return (Point(x: 0, y: 150 + x), .east)
                case 2:
                    return (Point(x: x, y: 199), .north)
                case 3: break
                case 4:
                    return (Point(x: 50, y: 50 + x), .east)
                case 5: break
                case 6: break
                default: break
                }
            case .south:
                switch currentFace {
                case 1: break
                case 2:
                    // Move to 3
                    return (Point(x: 99, y: 50 + x), .west)
                case 3: break
                case 4: break
                case 5:
                    // Move to 6
                    return (Point(x: 49, y: 150 + x), .west)
                case 6:
                    // Move to 2
                    return (Point(x: 100 + x, y: 0), .south)
                default: break
                }
            default: break
            }
            fatalError()
        }
        
        func moveTo(grid: [[String]], pos: Point, direction: Direction) -> Point {
            var newPos = pos
            switch direction {
            case .east:
                newPos.x = (newPos.x + 1) % grid[pos.y].count
                if grid[newPos.y][newPos.x] == " " {
                    newPos = moveTo(grid: grid, pos: newPos, direction: direction)
                }
            case .west:
                newPos.x = (newPos.x - 1) % grid[pos.y].count
                if newPos.x < 0 {
                    newPos.x += grid[pos.y].count
                }
                if grid[newPos.y][newPos.x] == " " {
                    newPos = moveTo(grid: grid, pos: newPos, direction: direction)
                }
            case .north:
                newPos.y = (newPos.y - 1) % grid.count
                if newPos.y < 0 {
                    newPos.y += grid.count
                }
                if newPos.x >= grid[newPos.y].count || grid[newPos.y][newPos.x] == " " {
                    newPos = moveTo(grid: grid, pos: newPos, direction: direction)
                }
            case .south:
                newPos.y = (newPos.y + 1) % grid.count
                if newPos.x >= grid[newPos.y].count || grid[newPos.y][newPos.x] == " " {
                    newPos = moveTo(grid: grid, pos: newPos, direction: direction)
                }
            default: break
            }
            return newPos
        }
        
        func moveToCube(grid: [[String]], pos: Point, direction: Direction) -> (Point, Direction) {
            var newPos = pos
            switch direction {
            case .east:
                newPos.x = newPos.x + 1
                if newPos.x >= grid[pos.y].count || grid[newPos.y][newPos.x] == " " {
                    return convert(grid: grid, pos: pos, direction: direction)
                }
            case .west:
                newPos.x = newPos.x - 1
                if newPos.x < 0 || grid[newPos.y][newPos.x] == " " {
                    return convert(grid: grid, pos: pos, direction: direction)
                }
            case .north:
                newPos.y = newPos.y - 1
                if newPos.y < 0 || newPos.x >= grid[newPos.y].count || grid[newPos.y][newPos.x] == " " {
                    return convert(grid: grid, pos: pos, direction: direction)
                }
            case .south:
                newPos.y = newPos.y + 1
                if newPos.y >= grid.count || newPos.x >= grid[newPos.y].count || grid[newPos.y][newPos.x] == " " {
                    return convert(grid: grid, pos: pos, direction: direction)
                }
            default: break
            }
            return (newPos, direction)
        }
        
        func part1() -> String {
            let components = input.blankLines
            let grid = components[0].gridNoSeparatorStrings
            let instructions = components[1]
            var turns = instructions.components(separatedBy: .decimalDigits).filter { !$0.isEmpty }
            let movements = instructions.components(separatedBy: .letters).filter { !$0.isEmpty }.ints
            
            var pos = Point(x: grid[0].firstIndex(where: { $0 == "." })!, y: 0)
            var direction = Direction.east
            
            for movement in movements {
                for _ in 0..<movement {
                    let newPos = moveTo(grid: grid, pos: pos, direction: direction)
                    if grid[newPos.y][newPos.x] == "." {
                        pos = newPos
                    }
                }
                
                if !turns.isEmpty {
                    switch turns.removeFirst() {
                    case "L":
                        direction.turnLeft()
                    case "R":
                        direction.turnRight()
                    default: break
                    }
                }
            }

            return "\(1000 * (pos.y + 1) + 4 * (pos.x + 1) + direction.facing)"
        }
        
        func part2() -> String {
            let components = input.blankLines
            let grid = components[0].gridNoSeparatorStrings
            let instructions = components[1]
            var turns = instructions.components(separatedBy: .decimalDigits).filter { !$0.isEmpty }
            let movements = instructions.components(separatedBy: .letters).filter { !$0.isEmpty }.ints
            
            var pos = Point(x: grid[0].firstIndex(where: { $0 == "." })!, y: 0)
            var direction = Direction.east
            
            for movement in movements {
                for _ in 0..<movement {
                    let newPos = moveToCube(grid: grid, pos: pos, direction: direction)
                    if grid[newPos.0.y][newPos.0.x] == "." {
                        pos = newPos.0
                        direction = newPos.1
                    }
                }
                
                if !turns.isEmpty {
                    switch turns.removeFirst() {
                    case "L":
                        direction.turnLeft()
                    case "R":
                        direction.turnRight()
                    default: break
                    }
                }
            }
            
            return "\(1000 * (pos.y + 1) + 4 * (pos.x + 1) + direction.facing)"
        }
    }
}
