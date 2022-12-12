//
//  2022-Day12.swift
//  AOC
//
//  Created by Micah Wilson on 12/12/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day12: Day {
        func part1() -> String {
            let grid = input.gridNoSeparatorStrings
            let testGrid = Array(repeating: Array(repeating: 1, count: grid.count), count: grid[0].count)
            var start = Point(x: 0, y: 0)
            var end = Point(x: 0, y: 0)
            grid.traverse { point in
                if grid[point.x][point.y] == "S" {
                    start = point
                } else if grid[point.x][point.y] == "E" {
                    end = point
                }
            }
            let test = testGrid.shortestPath(start: .init(x: start.y, y: start.x), end: .init(x: end.y, y: end.x)) { from, to in
                let fromString = grid[from.y][from.x].replacingOccurrences(of: "S", with: "a").unicodeScalars.first!.value
                let toString = grid[to.y][to.x].replacingOccurrences(of: "E", with: "z").unicodeScalars.first!.value
                return Int(fromString) - Int(toString) >= -1
            }
            
            return "\(test)"
        }
        
        func part2() -> String {
            let grid = input.gridNoSeparatorStrings
            let testGrid = Array(repeating: Array(repeating: 1, count: grid.count), count: grid[0].count)
            var starts = [Point]()
            var end = Point(x: 0, y: 0)
            grid.traverse { point in
                if grid[point.x][point.y] == "S" || grid[point.x][point.y] == "a" {
                    starts.append(.init(x: point.y, y: point.x))
                } else if grid[point.x][point.y] == "E" {
                    end = .init(x: point.y, y: point.x)
                }
            }
            
            let idealTrail = testGrid.shortestPath(start: end, ends: Set(starts)) { from, to in
                let fromString = grid[from.y][from.x].replacingOccurrences(of: "E", with: "z").unicodeScalars.first!.value
                let toString = grid[to.y][to.x].replacingOccurrences(of: "S", with: "a").unicodeScalars.first!.value
                return Int(toString) - Int(fromString) >= -1
            }
            
            return "\(idealTrail)"
        }
    }
}
