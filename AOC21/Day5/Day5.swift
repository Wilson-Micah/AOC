//
//  Day5.swift
//  AOC21
//
//  Created by Micah Wilson on 12/5/21.
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

struct Day5: Day {
    func overlappingPoints(includingDiagnals: Bool) -> String {
        let lines = input.lines
            .map { line -> Line in
                let components = line.components(separatedBy: " -> ")
                return Line(
                    start: .init(
                        x: Int(components[0].components(separatedBy: ",")[0])!,
                        y: Int(components[0].components(separatedBy: ",")[1])!
                    ),
                    end: .init(
                        x: Int(components[1].components(separatedBy: ",")[0])!,
                        y: Int(components[1].components(separatedBy: ",")[1])!
                    )
                )
            }
            .filter {
                $0.start.x == $0.end.x || $0.start.y == $0.end.y || includingDiagnals
            }
        
        var points = Set<Point>()
        var overlaps = Set<Point>()
        for line in lines {
            for point in line.points {
                if !points.insert(point).inserted {
                    overlaps.insert(point)
                }
            }
        }
        
        return "\(Set(overlaps).count)"
    }
    
    func part1() -> String {
        overlappingPoints(includingDiagnals: false)
    }
    
    func part2() -> String {
        overlappingPoints(includingDiagnals: true)
    }
}
