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
