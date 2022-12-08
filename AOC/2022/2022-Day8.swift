//
//  2022-Day8.swift
//  AOC
//
//  Created by Micah Wilson on 12/7/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day8: Day {
        func part1() -> String {
            let grid = input.gridNoSeparator
            var visiblePoints = Set([Point(x: 0, y: 0)])
            
            grid.traverse { point in
                grid.traverseNeighborsInSight(point: point, query: Set(Array(grid[point.x][point.y]...9)), reachedEnd: {
                    visiblePoints.insert(point)
                })
            }
            
            return "\(visiblePoints.count)"
        }
        
        func part2() -> String {
            let grid = input.gridNoSeparator
            var highScore = 0
            grid.traverseMiddle { point in
                var scenicScore = [Direction: Int]()
                grid.traverseNeighborsInSight(point: point, query: Set(Array(grid[point.x][point.y]...9)), value: { _, visiting in
                    scenicScore[point.directionTo(point: visiting), default: 0] += 1
                })
                highScore = max(highScore, scenicScore.values.reduce(into: 1, *=))
            }
            
            return "\(highScore)"
        }
    }
}
