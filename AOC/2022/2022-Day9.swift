//
//  2022-Day9.swift
//  AOC
//
//  Created by Micah Wilson on 12/9/22.
//

import Algorithms
import Foundation

private extension Point {
    func follow(_ point: inout Point) {
        if abs(point.x - x) <= 1 && abs(point.y - y) <= 1 {
            // Close enough don't move
            return
        }
        
        if point.x < x {
            point.x += 1
        }  else if point.x > x {
            point.x -= 1
        }
        
        if point.y < y {
            point.y += 1
        } else if point.y > y {
            point.y -= 1
        }
    }
}

extension AOC22 {
    struct Day9: Day {
        func part1() -> String {
            let data = input.lines
            var currentPoint = Point(x: 0, y: 0)
            var followingPoint = Point(x: 0, y: 0)
            var visitedPoints = Set([followingPoint])
            for line in data {
                let step = line.spaces
                for _ in 0..<Int(step[1])! {
                    switch step[0] {
                    case "R":
                        currentPoint.x += 1
                    case "U":
                        currentPoint.y -= 1
                    case "D":
                        currentPoint.y += 1
                    case "L":
                        currentPoint.x -= 1
                    default:
                        break
                    }
                    currentPoint.follow(&followingPoint)
                    visitedPoints.insert(followingPoint)
                }
            }
            return "\(visitedPoints.count)"
        }
        
        func part2() -> String {
            let data = input.lines
            var currentPoint = Point(x: 0, y: 0)
            var followingPoints = Array(repeating: Point(x: 0, y: 0), count: 9)
            var visitedPoints = Set<Point>()
            for line in data {
                let step = line.spaces
                for _ in 0..<Int(step[1])! {
                    switch step[0] {
                    case "R":
                        currentPoint.x += 1
                    case "U":
                        currentPoint.y -= 1
                    case "D":
                        currentPoint.y += 1
                    case "L":
                        currentPoint.x -= 1
                    default:
                        break
                    }
                    
                    for index in followingPoints.indices {
                        if index == 0 {
                            currentPoint.follow(&followingPoints[index])
                        } else {
                            followingPoints[index - 1].follow(&followingPoints[index])
                        }
                    }
                    
                    visitedPoints.insert(followingPoints.last!)
                }
            }
            return "\(visitedPoints.count)"
        }
    }
}
