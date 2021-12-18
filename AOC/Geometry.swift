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
