//
//  2022-Day14.swift
//  AOC
//
//  Created by Micah Wilson on 12/13/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day14: Day {
        @discardableResult
        func dropSand(rocks: inout Set<Point>, highest: Point, lowest: Int) -> Point {
            if highest.y >= lowest {
                return highest
            } else if !rocks.contains(.init(x: highest.x, y: highest.y + 1)) {
                dropSand(rocks: &rocks, highest: .init(x: highest.x, y: highest.y + 1), lowest: lowest)
                return .init(x: highest.x, y: highest.y + 1)
            } else if !rocks.contains(.init(x: highest.x - 1, y: highest.y + 1)) {
                dropSand(rocks: &rocks, highest: .init(x: highest.x - 1, y: highest.y + 1), lowest: lowest)
                return .init(x: highest.x, y: highest.y + 1)
            } else if !rocks.contains(.init(x: highest.x + 1, y: highest.y + 1)) {
                dropSand(rocks: &rocks, highest: .init(x: highest.x + 1, y: highest.y + 1), lowest: lowest)
                return .init(x: highest.x, y: highest.y + 1)
            } else {
                rocks.insert(.init(x: highest.x, y: highest.y))
                return highest
            }
        }
        
        func part1() -> String {
            var rocks = input.lines.map { line in
                let components = line.components(separatedBy: " -> ")
                var rocks = Set<Point>()
                let windows = components.windows(ofCount: 2)
                for window in windows {
                    let from = window.first!
                    let to = window.last!
                    let xs = [Int(to.commas[0])!, Int(from.commas[0])!]
                    let ys = [Int(to.commas[1])!, Int(from.commas[1])!]
                    for x in xs.min()!...xs.max()! {
                        for y in ys.min()!...ys.max()! {
                            rocks.insert(.init(x: x, y: y))
                        }
                    }
                }
                return rocks
            }
                .reduce(into: Set<Point>()) { partialResult, points in
                    partialResult.formUnion(points)
                }
            
            var highest = rocks.filter { $0.x == 500 }.min(by: { $0.y < $1.y})!
            let lowest = rocks.max(by: { $0.y < $1.y})!
            
            var droppedSand = 0
            while !rocks.contains(where: { $0.y > lowest.y }) {
                let addedSand = rocks.count
                highest = dropSand(rocks: &rocks, highest: .init(x: highest.x, y: highest.y - 1), lowest: lowest.y)
                if rocks.count == addedSand {
                    break
                } else {
                    droppedSand += 1
                }
            }
            
            return "\(droppedSand)"
        }
        
        func part2() -> String {
            var rocks = input.lines.map { line in
                let components = line.components(separatedBy: " -> ")
                var rocks = Set<Point>()
                let windows = components.windows(ofCount: 2)
                for window in windows {
                    let from = window.first!
                    let to = window.last!
                    let xs = [Int(to.commas[0])!, Int(from.commas[0])!]
                    let ys = [Int(to.commas[1])!, Int(from.commas[1])!]
                    for x in xs.min()!...xs.max()! {
                        for y in ys.min()!...ys.max()! {
                            rocks.insert(.init(x: x, y: y))
                        }
                    }
                }
                return rocks
            }
                .reduce(into: Set<Point>()) { partialResult, points in
                    partialResult.formUnion(points)
                }
            
            var highest = rocks.filter { $0.x == 500 }.min(by: { $0.y < $1.y})!
            let lowest = rocks.max(by: { $0.y < $1.y})!.y + 2
            
            for i in -lowest...lowest {
                rocks.insert(.init(x: 500 + i, y: lowest))
            }
            
            var droppedSand = 0
            while true {
                highest = dropSand(rocks: &rocks, highest: .init(x: highest.x, y: highest.y - 1), lowest: lowest)
                droppedSand += 1
                if rocks.contains(.init(x: 500, y: 0)) {
                    break
                }
            }
            
            return "\(droppedSand)"
        }
    }
}
