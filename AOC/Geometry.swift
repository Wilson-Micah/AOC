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
    
    func manhattenTo(point: Point) -> Int {
        return abs(point.x - x) + abs(point.y - y)
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

protocol PointProtocol: Hashable {
    func isTouching(point: Self) -> Bool
    var adjacentCubes: Set<Self> { get }
}

struct Point3D: PointProtocol {
    var x: Int
    var y: Int
    var z: Int
    
    var manhatten: Int {
        x + y + z
    }
    
    var rotateX: Point3D {
        return .init(x: -y, y: x, z: z)
    }
    
    var rotateY: Point3D {
        return .init(x: x, y: -z, z: y)
    }
    
    var rotateZ: Point3D {
        return .init(x: z, y: y, z: -x)
    }
    
    var rotations: Array<Rotation> {
        var points = [Rotation]()
        var uniquePoints = Set<Point3D>()
        var point = self
        for x in 0...3 {
            for y in 0...3 {
                for z in 0...3 {
                    if uniquePoints.insert(point).inserted {
                        points.append(.init(point: point, rotation: .init(x: x, y: y, z: z)))
                    }
                    point = point.rotateZ
                }
                point = point.rotateY
            }
            point = point.rotateX
        }
        return points
    }
    
    func offset(point: Point3D) -> Point3D {
        .init(x: point.x + x, y: point.y + y, z: point.z + z)
    }
    
    func applyingRotation(point: Point3D) -> Point3D {
        var rotatedPoint = self
        for _ in 0..<point.x {
            rotatedPoint = rotatedPoint.rotateX
        }
        for _ in 0..<point.y {
            rotatedPoint = rotatedPoint.rotateY
        }
        for _ in 0..<point.z {
            rotatedPoint = rotatedPoint.rotateZ
        }
        return rotatedPoint
    }
    
    func isTouching(point: Point3D) -> Bool {
        return abs(point.x - x) <= 1 && abs(point.y - y) <= 1 && abs(point.z - z) <= 1
    }
    
    var adjacentCubes: Set<Point3D> {
        var points = Set<Point3D>()
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    points.insert(.init(x: self.x + x, y: self.y + y, z: self.z + z))
                }
            }
        }
        return points.subtracting([self])
    }
    
    var touchingCubes: Set<Point3D> {
        Set([
            Point3D(x: self.x + 1, y: self.y, z: self.z),
            Point3D(x: self.x - 1, y: self.y, z: self.z),
            Point3D(x: self.x, y: self.y + 1, z: self.z),
            Point3D(x: self.x, y: self.y - 1, z: self.z),
            Point3D(x: self.x, y: self.y, z: self.z + 1),
            Point3D(x: self.x, y: self.y, z: self.z - 1)
        ])
    }
    
    func hasKnownOutlet(_ point: Set<Point3D>) -> Bool {
       ![
        point.contains(where: { $0.x < x && $0.y == y && $0.z == z }),
        point.contains(where: { $0.x > x && $0.y == y && $0.z == z }),
        point.contains(where: { $0.y < y && $0.x == x && $0.z == z }),
        point.contains(where: { $0.y > y && $0.x == x && $0.z == z }),
        point.contains(where: { $0.z > z && $0.y == y && $0.x == x }),
        point.contains(where: { $0.z < z && $0.y == y && $0.x == x })
       ].allSatisfy { $0 }
    }
}

struct Point4D: PointProtocol {
    var w: Int
    var x: Int
    var y: Int
    var z: Int
    
    var manhatten: Int {
        w + x + y + z
    }
    
    func isTouching(point: Point4D) -> Bool {
        abs(point.w - w) <= 1 && abs(point.x - x) <= 1 && abs(point.y - y) <= 1 && abs(point.z - z) <= 1
    }
    
    var adjacentCubes: Set<Point4D> {
        var points = Set<Point4D>()
        for w in -1...1 {
            for x in -1...1 {
                for y in -1...1 {
                    for z in -1...1 {
                        points.insert(.init(w: self.w + w, x: self.x + x, y: self.y + y, z: self.z + z))
                    }
                }
            }
        }
        return points.subtracting([self])
    }
}
