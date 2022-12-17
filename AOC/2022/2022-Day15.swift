//
//  2022-Day15.swift
//  AOC
//
//  Created by Micah Wilson on 12/15/22.
//

import Algorithms
import CoreGraphics
import Foundation

extension AOC22 {
    struct Trapazoid: Hashable {
        let top: Point
        let bottom: Point
        let right: Point
        let left: Point
        var midPoint: Point {
            .init(x: (right.x + left.x) / 2, y: (bottom.y + top.y) / 2)
        }
        
        var height: Int {
            abs(bottom.y - top.y)
        }
        
        func contains(point: Point) -> Bool {
            point.x >= left.x && point.x <= right.x && point.y >= top.y && point.y <= bottom.y && point.manhattenTo(point: midPoint) <= left.manhattenTo(point: midPoint)
        }
        
        var borderingPoints: [Point] {
            var points = [Point]()
            let distance = bottom.manhattenTo(point: midPoint)
            for y in (top.y - 1)...(bottom.y + 1) {
                if y < top.y || y > bottom.y {
                    points.append(.init(x: top.x, y: y))
                } else {
                    let offset = (distance - abs(y - midPoint.y)) + 1
                    points.append(.init(x: top.x - offset, y: y))
                    points.append(.init(x: top.x + offset, y: y))
                }
            }
            return points
        }
    }
    
    struct Day15: Day {
        func part1() -> String {
            var beacons = [Point: [Point]]()
            let searchY = 2000000
            for line in input.lines {
                let components = line.components(separatedBy: ":")
                let sensorX = Int(components[0].components(separatedBy: "x=")[1].commas[0])!
                let sensorY = Int(components[0].components(separatedBy: ", y=")[1])!
                let beaconX = Int(components[1].components(separatedBy: "x=")[1].commas[0])!
                let beaconY = Int(components[1].components(separatedBy: ", y=")[1])!
                beacons[.init(x: beaconX, y: beaconY), default: []].append(.init(x: sensorX, y: sensorY))
            }
            
            var trapazoids = [Trapazoid]()
            for (beacon, sensors) in beacons {
                for sensor in sensors {
                    let distance = sensor.manhattenTo(point: beacon)
                    trapazoids.append(Trapazoid(
                        top: .init(x: sensor.x, y: sensor.y - distance),
                        bottom: .init(x: sensor.x, y: sensor.y + distance),
                        right: .init(x: sensor.x + distance, y: sensor.y),
                        left: .init(x: sensor.x - distance, y: sensor.y)
                    ))
                }
            }
            
            let touchingTrapazoids = trapazoids.filter { $0.top.y < searchY && $0.bottom.y > searchY }
            var points = [ClosedRange<Int>]()
            for trap in touchingTrapazoids {
                let distance = trap.bottom.manhattenTo(point: trap.midPoint)
                let offset = distance - abs(searchY - trap.midPoint.y)
                
                points.append((trap.midPoint.x - offset)...(trap.midPoint.x + offset))
            }
            
            
            var ranges = [ClosedRange<Int>]()
            for range in points.sorted(by: { $0.lowerBound < $1.lowerBound }) {
                if let index = ranges.firstIndex(where: { $0.overlaps(range) }) {
                    ranges[index].formUnion(range)
                } else {
                    ranges.append(range)
                }
            }
            let beaconCount = ranges.reduce(into: 0) { partialResult, range in
                partialResult += range.count
            }
            
            return "\(beaconCount - beacons.keys.filter { $0.y == searchY }.count)"
        }
        
        func part2() -> String {
            var beacons = [Point: [Point]]()
            for line in input.lines {
                let components = line.components(separatedBy: ":")
                let sensorX = Int(components[0].components(separatedBy: "x=")[1].commas[0])!
                let sensorY = Int(components[0].components(separatedBy: ", y=")[1])!
                let beaconX = Int(components[1].components(separatedBy: "x=")[1].commas[0])!
                let beaconY = Int(components[1].components(separatedBy: ", y=")[1])!
                beacons[.init(x: beaconX, y: beaconY), default: []].append(.init(x: sensorX, y: sensorY))
            }
            
            var trapazoids = [Trapazoid]()
            for (beacon, sensors) in beacons.sorted(by: { $0.key.x > $1.key.x }) {
                for sensor in sensors {
                    let distance = sensor.manhattenTo(point: beacon)
                    trapazoids.append(Trapazoid(
                        top: .init(x: sensor.x, y: sensor.y - distance),
                        bottom: .init(x: sensor.x, y: sensor.y + distance),
                        right: .init(x: sensor.x + distance, y: sensor.y),
                        left: .init(x: sensor.x - distance, y: sensor.y)
                    ))
                }
            }

            for trapazoid in trapazoids {
                for point in trapazoid.borderingPoints where point.x >= 0 && point.y >= 0 && point.x <= 4000000 && point.y <= 4000000 {
                    if trapazoids.allSatisfy({ !$0.contains(point: point) }) {
                        return "\(point.x * 4000000 + point.y)"
                    }
                }
            }
            
            return ""
        }
    }
}
