//
//  2022-Day17.swift
//  AOC
//
//  Created by Micah Wilson on 12/16/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Shape: Hashable {
        static let shapes = [
            Shape(points: [
                Point(x: 0, y: 0),
                Point(x: 1, y: 0),
                Point(x: 2, y: 0),
                Point(x: 3, y: 0)
            ]),
            Shape(points: [
                Point(x: 1, y: 0),
                Point(x: 0, y: 1),
                Point(x: 1, y: 1),
                Point(x: 2, y: 1),
                Point(x: 1, y: 2)
            ]),
            Shape(points: [
                Point(x: 2, y: 2),
                Point(x: 2, y: 1),
                Point(x: 2, y: 0),
                Point(x: 1, y: 0),
                Point(x: 0, y: 0)
            ]),
            Shape(points: [
                Point(x: 0, y: 3),
                Point(x: 0, y: 2),
                Point(x: 0, y: 1),
                Point(x: 0, y: 0)
            ]),
            Shape(points: [
                Point(x: 0, y: 0),
                Point(x: 0, y: 1),
                Point(x: 1, y: 0),
                Point(x: 1, y: 1)
            ])
        ]
        var points = [Point]()
        
        var leftEdge: Int {
            points.lazy.map(\.x).min()!
        }
        
        var rightEdge: Int {
            points.lazy.map(\.x).min()!
        }
        
        mutating func shiftLeft(count: Int = 1) {
            guard points.map(\.x).min()! > 0 else { return }
            for i in points.indices {
                points[i].x -= count
            }
        }
        
        mutating func shiftRight(count: Int = 1) {
            guard points.map(\.x).max()! < 6 else { return }
            for i in points.indices {
                points[i].x += count
            }
        }
        
        mutating func drop(count: Int = 1) {
            for i in points.indices {
                points[i].y -= count
            }
        }
    }
    
    struct Day17: Day {
        func part1() -> String {
            var currentShapes = Set<Point>()
            var maxY = 0
            var shapeIndex = 0
            let jetStreams = Array(input)
            var currentShape: Shape!
            var jetStreamIndex = 0
            
            func spawnNewShape() {
                currentShape = Shape.shapes[shapeIndex % Shape.shapes.count]
                currentShape.drop(count: -(maxY + 4))
                currentShape.shiftRight(count: 2)
                shapeIndex += 1
            }
            
            spawnNewShape()
            
            func canDrop() -> Bool {
                !currentShape.points.contains(where: { currentShapes.contains(.init(x: $0.x, y: $0.y - 1)) || ($0.y - 1) == 0 })
            }
            
            func canShiftRight() -> Bool {
                !currentShape.points.contains(where: { currentShapes.contains(.init(x: $0.x + 1, y: $0.y)) })
            }
            
            func canShiftLeft() -> Bool {
                !currentShape.points.contains(where: { currentShapes.contains(.init(x: $0.x - 1, y: $0.y)) })
            }
            
            while shapeIndex <= 2022 {
                let stream = jetStreams[jetStreamIndex % jetStreams.count]
                jetStreamIndex += 1
                if stream == "<" && canShiftLeft() {
                    currentShape.shiftLeft()
                } else if stream == ">" && canShiftRight() {
                    currentShape.shiftRight()
                }
                if canDrop() {
                    currentShape.drop()
                } else {
                    currentShape.points.forEach { currentShapes.insert($0) }
                    maxY = max(maxY, currentShape.points.map(\.y).max()!)
                    spawnNewShape()
                }
            }
            
            return "\(maxY)"
        }
        
        func part2() -> String {
            var currentShapes = Set<Point>()
            var maxY = 0
            var shapeIndex = 0
            let jetStreams = Array(input)
            var currentShape: Shape!
            var jetStreamIndex = 0
            let rocks = 1000000000000
            var additionalHeight = 0
            func spawnNewShape() {
                currentShape = Shape.shapes[shapeIndex % Shape.shapes.count]
                currentShape.drop(count: -(maxY + 4))
                currentShape.shiftRight(count: 2)
                shapeIndex += 1
            }
            
            spawnNewShape()
            
            func canDrop() -> Bool {
                !currentShape.points.contains(where: { currentShapes.contains(.init(x: $0.x, y: $0.y - 1)) || ($0.y - 1) == 0 })
            }
            
            func canShiftRight() -> Bool {
                !currentShape.points.contains(where: { currentShapes.contains(.init(x: $0.x + 1, y: $0.y)) })
            }
            
            func canShiftLeft() -> Bool {
                !currentShape.points.contains(where: { currentShapes.contains(.init(x: $0.x - 1, y: $0.y)) })
            }
            
            var normalizedStarts = [[Int]: (Int, Int, Int)]()
            
            
            func addNormalizedStart() {
                guard additionalHeight == 0 else { return }
                let maxAtX = (0..<7).compactMap { i in currentShapes.filter { $0.x == i }.map(\.y).max() }
                let min = maxAtX.min()!
                let normalized = maxAtX.map { $0 - min }
                
                if let (jetStream, lastCount, y) = normalizedStarts[normalized], (jetStreamIndex - jetStream) % jetStreams.count == 0 {
                    let totalRocks = rocks - lastCount
                    let cycleLength = shapeIndex - lastCount
                    let remainingRocks = totalRocks % cycleLength
                    let cycleHeight = maxY - y
                    additionalHeight = ((totalRocks / cycleLength) * cycleHeight) - (maxY - y)
                    shapeIndex = rocks - remainingRocks
                } else {
                    normalizedStarts[normalized] = (jetStreamIndex, shapeIndex, maxY)
                }
            }
            
            while shapeIndex <= rocks {
                let stream = jetStreams[jetStreamIndex % jetStreams.count]
                jetStreamIndex += 1
                if stream == "<" && canShiftLeft() {
                    currentShape.shiftLeft()
                } else if stream == ">" && canShiftRight() {
                    currentShape.shiftRight()
                }
                if canDrop() {
                    currentShape.drop()
                } else {
                    currentShape.points.forEach { currentShapes.insert($0) }
                    maxY = max(maxY, currentShape.points.map(\.y).max()!)
                    spawnNewShape()
                    addNormalizedStart()
                }
            }
            
            return "\(maxY + additionalHeight)"
        }
    }
}
