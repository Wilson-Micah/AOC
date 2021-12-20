//
//  2021-Day19.swift
//  AOC
//
//  Created by Micah Wilson on 12/18/21.
//

import Algorithms
import Foundation

struct Rotation: Hashable {
    var point: Point3D
    var rotation: Point3D
}

struct Point3D: Hashable {
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
}

extension AOC21 {
    struct Scanner: Hashable {
        var beacons = Set<Point3D>()
        var rotations: Set<Rotation>
        
        init(beacons: Set<Point3D>) {
            self.beacons = beacons
            self.rotations = Set(beacons.flatMap { $0.rotations })
        }
        
        func offsets(from: Scanner) -> [Rotation: Int] {
            var offsets = [Rotation: Int]()
            for beacon in beacons {
                for rotation in from.rotations {
                    offsets[Rotation(point: Point3D(x: beacon.x - rotation.point.x, y: beacon.y - rotation.point.y, z: beacon.z - rotation.point.z), rotation: rotation.rotation), default: 0] += 1
                }
            }
            return offsets
        }
    }
    
    struct Day19: Day {
        var offsets = [Scanner: [Rotation]]()
        
        init() {
            self.offsets = scannerOffsets
        }
        
        var scanners: [Scanner] {
            input.components(separatedBy: "\n\n")
                .map { scanner -> Scanner in
                    let beacons = scanner.lines.dropFirst()
                    let points = beacons
                        .map { line -> Point3D in
                            let position = line.components(separatedBy: ",").ints
                            return Point3D(x: position[0], y: position[1], z: position[2])
                        }
                    return Scanner(beacons: Set(points))
                }
        }
        
        var scannerOffsets: [Scanner: [Rotation]] {
            let scanners = scanners
            var offsetsFromBase = [scanners.first!: [Rotation(point: .init(x: 0, y: 0, z: 0), rotation: .init(x: 0, y: 0, z: 0))]]
            var offsetsToTry = offsetsFromBase
            let scannersToOffset = Array(scanners.dropFirst())
            while offsetsFromBase.count != scanners.count {
                let attempts = offsetsToTry
                offsetsToTry = [:]
                for (comparison, offset) in attempts {
                    for scanner in scannersToOffset where offsetsFromBase[scanner] == nil {
                        let offsets = comparison.offsets(from: scanner).filter { $0.value >= 12 }
                        if let (foundRotation, _) = offsets.first {
                            let result = offset + [.init(point: foundRotation.point, rotation: foundRotation.rotation)]
                            offsetsFromBase[scanner] = result
                            offsetsToTry[scanner] = result
                        }
                    }
                }
            }
            
            return offsetsFromBase
        }
        
        func part1() -> String {
            var beacons = Set<Point3D>()
            for (scanner, offsets) in offsets {
                for var beacon in scanner.beacons {
                    for offset in offsets.reversed() {
                        beacon = beacon.applyingRotation(point: offset.rotation).offset(point: offset.point)
                    }
                    beacons.insert(beacon)
                }
            }
            
            return "\(beacons.count)"
        }
        
        func part2() -> String {
            var scannerPositions = [Point3D]()
            for (_, offsets) in offsets {
                var position = Point3D(x: 0, y: 0, z: 0)
                for offset in offsets.reversed() {
                    position = position.applyingRotation(point: offset.rotation).offset(point: offset.point)
                }
                scannerPositions.append(position)
            }
            
            let manhattenDistances = scannerPositions.map(\.manhatten).minAndMax()!
            return "\(manhattenDistances.max - manhattenDistances.min)"
        }
    }
}
