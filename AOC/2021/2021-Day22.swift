//
//  2021-Day22.swift
//  AOC
//
//  Created by Micah Wilson on 12/21/21.
//

import Algorithms
import Foundation

extension ClosedRange where Bound == Int {
    func subtract(_ range: ClosedRange<Int>) -> [ClosedRange<Int>] {
        if lowerBound < range.lowerBound && upperBound > range.upperBound {
            return [lowerBound...(range.lowerBound - 1), (range.upperBound + 1)...upperBound]
        } else if lowerBound < range.lowerBound && upperBound >= range.lowerBound {
            return [lowerBound...(range.lowerBound - 1)]
        } else if upperBound > range.upperBound && lowerBound <= range.upperBound {
            return [(range.upperBound + 1)...upperBound]
        } else if lowerBound >= range.lowerBound && upperBound <= range.upperBound {
            return []
        } else {
            return [self]
        }
    }
    
    func unioned(_ range: ClosedRange<Int>) -> ClosedRange<Int> {
        return Swift.min(self.lowerBound, range.lowerBound)...Swift.max(self.upperBound, range.upperBound)
    }
    
    mutating func formUnion(_ range: ClosedRange<Int>) {
        self = unioned(range)
    }
}

extension AOC21 {
    struct Day22: Day {
        struct Range3D: Hashable {
            var xRange: ClosedRange<Int>
            var yRange: ClosedRange<Int>
            var zRange: ClosedRange<Int>
            
            func overlaps(_ range: Range3D) -> Bool {
                return xRange.overlaps(range.xRange) && yRange.overlaps(range.yRange) && zRange.overlaps(range.zRange)
            }
            
            func removeOverlap(_ range: Range3D) -> [Range3D] {
                var ranges = [Range3D]()
                for r in range.xRange.subtract(xRange) {
                    ranges.append(Range3D(xRange: r, yRange: range.yRange, zRange: range.zRange))
                }
                
                for r in range.yRange.subtract(yRange) {
                    ranges.append(Range3D(xRange: range.xRange.overlaps(xRange) ? range.xRange.clamped(to: xRange) : range.xRange, yRange: r, zRange: range.zRange))
                }
                
                for r in range.zRange.subtract(zRange) {
                    ranges.append(Range3D(xRange: range.xRange.overlaps(xRange) ? range.xRange.clamped(to: xRange) : range.xRange, yRange: range.yRange.overlaps(yRange) ? range.yRange.clamped(to: yRange) : range.yRange, zRange: r))
                }
                return ranges
            }
            
            var cubes: Int {
                (xRange.upperBound - xRange.lowerBound + 1) * (yRange.upperBound - yRange.lowerBound + 1) * (zRange.upperBound - zRange.lowerBound + 1)
            }
        }
        
        struct Step {
            let on: Bool
            let range: Range3D
        }

        
        func runInput(limit50: Bool) -> String {
            var onRanges = Set<Range3D>()
            input.lines.forEach { line in
                let xRange = line.components(separatedBy: "x=")[1].components(separatedBy: ",")[0]
                let yRange = line.components(separatedBy: "y=")[1].components(separatedBy: ",")[0]
                let zRange = line.components(separatedBy: "z=")[1]
                let xMin = Int(xRange.components(separatedBy: "..")[0])!
                let xMax = Int(xRange.components(separatedBy: "..")[1])!
                let yMin = Int(yRange.components(separatedBy: "..")[0])!
                let yMax = Int(yRange.components(separatedBy: "..")[1])!
                let zMin = Int(zRange.components(separatedBy: "..")[0])!
                let zMax = Int(zRange.components(separatedBy: "..")[1])!
                let on = line.components(separatedBy: " ")[0] == "on"
                
                if limit50 && (xMin < -50 || xMax > 50 || yMin < -50 || yMax > 50 || zMin < -50 || zMax > 50) {
                    return
                }

                let range = Range3D(xRange: xMin...xMax, yRange: yMin...yMax, zRange: zMin...zMax)
                if on {
                    var removedOverlappingRanges = Set([range])
                    let overlaps = onRanges.filter { $0.overlaps(range) }.sorted(by: { $0.cubes > $1.cubes })
                    for overlap in overlaps {
                        removedOverlappingRanges = Set(removedOverlappingRanges.flatMap { overlap.overlaps($0) ? overlap.removeOverlap($0) : [$0] })
                    }

                    for r in removedOverlappingRanges {
                        onRanges.insert(r)
                    }
                } else {
                    var removedOverlappingRanges = Set<Range3D>()

                    let overlaps = onRanges.filter { $0.overlaps(range) }.sorted(by: { $0.cubes > $1.cubes })
                    for overlap in overlaps {
                        onRanges.remove(overlap)
                        removedOverlappingRanges.formUnion(Set(range.removeOverlap(overlap)))
                    }

                    for r in removedOverlappingRanges {
                        onRanges.insert(r)
                    }
                }
            }
            
            return "\(onRanges.map(\.cubes).reduce(into: 0, +=))"
        }
        
        func part1() -> String {
            return runInput(limit50: true)
        }
        
        func part2() -> String {
            return runInput(limit50: false)
        }
    }
}
