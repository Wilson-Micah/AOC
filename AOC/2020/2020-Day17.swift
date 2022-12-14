//
//  2020-Day17.swift
//  AOC
//
//  Created by Micah Wilson on 12/13/22.
//

extension AOC20 {
    struct Day17: Day {
        func toggleLights<P: PointProtocol>(on: inout Set<P>) {
            var newOn = Set<P>()
            for point in on {
                let onNeighbors = on.filter { $0.isTouching(point: point) && $0 != point }
                if onNeighbors.count == 2 || onNeighbors.count == 3 {
                    newOn.insert(point)
                }
                
                for adjacent in point.adjacentCubes.filter({ !on.contains($0) }) {
                    if on.filter({ $0.isTouching(point: adjacent) && $0 != adjacent }).count == 3 {
                        newOn.insert(adjacent)
                    }
                }
            }
            on = newOn
        }
        
        func part1() -> String {
            let data = input.gridNoSeparatorStrings
            var onPoints = Set<Point3D>()
            data.traverse { point in
                if data[point.x][point.y] == "#" {
                    onPoints.insert(.init(x: point.x, y: point.y, z: 0))
                }
            }
            
            for _ in 0..<6 {
                toggleLights(on: &onPoints)
            }
            
            return "\(onPoints.count)"
        }
        
        func part2() -> String {
            let data = input.gridNoSeparatorStrings
            var onPoints = Set<Point4D>()
            data.traverse { point in
                if data[point.x][point.y] == "#" {
                    onPoints.insert(.init(w: 0, x: point.x, y: point.y, z: 0))
                }
            }
            
            for _ in 0..<6 {
                toggleLights(on: &onPoints)
            }
            
            return "\(onPoints.count)"
        }
    }
}
