//
//  Geometry.swift
//  AOC
//
//  Created by Micah Wilson on 12/17/21.
//

import Foundation

struct Point: Hashable {
    var x: Int
    var y: Int
}

extension Point {
    var neighbors: [Point] {
        [
            Point(x: x, y: y - 1),
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x, y: y + 1),
        ]
    }
    
    var neighborsInclusive: [Point] {
        [
            Point(x: x, y: y - 1),
            Point(x: x - 1, y: y),
            self,
            Point(x: x + 1, y: y),
            Point(x: x, y: y + 1),
        ]
    }
    
    var adjacent: [Point] {
        [
            Point(x: x - 1, y: y - 1),
            Point(x: x, y: y - 1),
            Point(x: x + 1, y: y - 1),
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x - 1, y: y + 1),
            Point(x: x, y: y + 1),
            Point(x: x + 1, y: y + 1)
        ]
    }
    
    var adjacentInclusive: [Point] {
        [
            Point(x: x - 1, y: y - 1),
            Point(x: x, y: y - 1),
            Point(x: x + 1, y: y - 1),
            Point(x: x - 1, y: y),
            self,
            Point(x: x + 1, y: y),
            Point(x: x - 1, y: y + 1),
            Point(x: x, y: y + 1),
            Point(x: x + 1, y: y + 1)
        ]
    }
    
    func directionTo(point: Point) -> Direction {
        if point.x < x && point.y == y {
            return .west
        } else if point.x > x && point.y == y {
            return .east
        } else if point.x < x && point.y < y {
            return .northWest
        } else if point.x > x && point.y < y {
            return .northEast
        } else if point.x < x && point.y > y {
            return .southWest
        } else if point.x > x && point.y > y {
            return .southEast
        } else if point.x == x && point.y < y {
            return .north
        } else if point.x == x && point.y > y {
            return .south
        } else {
            fatalError("Points are the same")
        }
        
    }
}

enum Direction: Hashable {
    case east
    case north
    case south
    case west
    case northEast
    case northWest
    case southEast
    case southWest
    
    mutating func turnLeft() {
        switch self {
        case .east:
            self = .north
        case .north:
            self = .west
        case .west:
            self = .south
        case .south:
            self = .east
        case .northEast:
            self = .northWest
        case .northWest:
            self = .southWest
        case .southEast:
            self = .northEast
        case .southWest:
            self = .southEast
        }
    }
    
    mutating func turnRight() {
        switch self {
        case .east:
            self = .south
        case .north:
            self = .east
        case .west:
            self = .north
        case .south:
            self = .west
        case .northEast:
            self = .southEast
        case .northWest:
            self = .northEast
        case .southEast:
            self = .southWest
        case .southWest:
            self = .northWest
        }
    }
}

struct Line: Hashable {
    let start: Point
    let end: Point
    var points: Set<Point>
    
    init(start: Point, end: Point) {
        self.start = start
        self.end = end
        
        points = [start]
        var currentPoint = start
        while currentPoint != end {
            currentPoint.x += currentPoint.x != end.x ? (currentPoint.x < end.x ? 1 : -1) : 0
            currentPoint.y += currentPoint.y != end.y ? (currentPoint.y < end.y ? 1 : -1) : 0
            points.insert(currentPoint)
        }
    }
    
    func overlappingPoints(_ line: Line) -> [Point] {
        Array(points.intersection(line.points))
    }
}
