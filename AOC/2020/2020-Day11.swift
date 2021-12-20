//
//  2020-Day11.swift
//  AOC
//
//  Created by Micah Wilson on 12/20/21.
//

import Algorithms
import Foundation

extension AOC20 {
    struct Day11: Day {
        func advanceRoundAdjacent(seatMap: [[String]]) -> [[String]] {
            var adjustedMap = seatMap
            seatMap.traverse { point in
                var occupiedCount = 0
                seatMap.traverseAdjacent(point: point) { value in
                    occupiedCount += value == "#" ? 1 : 0
                }
                
                if seatMap[point.x][point.y] == "L" && occupiedCount == 0 {
                    adjustedMap[point.x][point.y] = "#"
                } else if seatMap[point.x][point.y] == "#" && occupiedCount >= 4 {
                    adjustedMap[point.x][point.y] = "L"
                }
            }
            
            return adjustedMap
        }
        
        func advanceRoundFirstDirection(seatMap: [[String]]) -> [[String]] {
            var adjustedMap = seatMap
            seatMap.traverse { point in
                var occupiedCount = 0
                seatMap.traverseAdjacentInSight(point: point, query: ["#", "L"]) { value, _ in
                    occupiedCount += value == "#" ? 1 : 0
                }
                
                if seatMap[point.x][point.y] == "L" && occupiedCount == 0 {
                    adjustedMap[point.x][point.y] = "#"
                } else if seatMap[point.x][point.y] == "#" && occupiedCount >= 5 {
                    adjustedMap[point.x][point.y] = "L"
                }
            }
            
            return adjustedMap
        }
        
        func part1() -> String {
            var seatMap = input.columns
            var advanced = seatMap
            repeat {
                seatMap = advanced
                advanced = advanceRoundAdjacent(seatMap: advanced)
            } while seatMap != advanced
            return "\(seatMap.count(of: "#"))"
        }
        
        func part2() -> String {
            var seatMap = input.columns
            var advanced = seatMap
            repeat {
                seatMap = advanced
                advanced = advanceRoundFirstDirection(seatMap: advanced)
            } while seatMap != advanced
            return "\(seatMap.count(of: "#"))"
        }
    }
}
