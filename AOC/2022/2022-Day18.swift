//
//  2022-Day18.swift
//  AOC
//
//  Created by Micah Wilson on 12/18/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day18: Day {
        func part1() -> String {
            let cubes = input.lines.map {
                let components = $0.commas.ints
                return Point3D(x: components[0], y: components[1], z: components[2])
            }
            
            var allCubes = Set<Point3D>()
            var totalExposedSides = 0
            
            for cube in cubes {
                let connectedSides = cube.touchingCubes.filter { allCubes.contains($0) }
                totalExposedSides += (6 - connectedSides.count) - connectedSides.count
                allCubes.insert(cube)
            }
            return "\(totalExposedSides)"
        }
        
        func part2() -> String {
            let cubes = input.lines.map {
                let components = $0.commas.ints
                return Point3D(x: components[0], y: components[1], z: components[2])
            }
            
            var allCubes = Set<Point3D>()
            var totalExposedSides = 0
            
            for cube in cubes {
                let connectedSides = cube.touchingCubes.filter { allCubes.contains($0) }
                totalExposedSides += (6 - connectedSides.count) - connectedSides.count
                allCubes.insert(cube)
            }
            
            let exposedCubes = Set(cubes.flatMap { $0.touchingCubes }.filter { !allCubes.contains($0) })
            
            var filteredCubes = exposedCubes.filter { $0.hasKnownOutlet(allCubes) }
            var containedCubes = exposedCubes.filter { !$0.hasKnownOutlet(allCubes) }
            var filtered = true
            while filtered {
                let reducedContained = containedCubes.filter { reduced in
                    if reduced.touchingCubes.contains(where: { filteredCubes.contains($0) }) {
                        filteredCubes.insert(reduced)
                        return false
                    } else {
                        return true
                    }
                }
                if reducedContained.count == containedCubes.count {
                    filtered = false
                }
                containedCubes = reducedContained
            }
            
            var totalExposedAir = 0
            for cube in containedCubes {
                let connectedSides = cube.touchingCubes.filter { allCubes.contains($0) }
                totalExposedAir += connectedSides.count
            }

            return "\(totalExposedSides - totalExposedAir)"
        }
    }
}
