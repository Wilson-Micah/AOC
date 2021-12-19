//
//  Day6.swift
//  AOC21
//
//  Created by Micah Wilson on 12/5/21.
//

import Foundation

extension AOC21 {
    struct Day6: Day {
        func passTime(days: Int) -> String {
            var fishMap = input
                .components(separatedBy: ",")
                .ints
                .reduce(into: [Int: Int]()) { partialResult, value in
                    partialResult[value, default: 0] += 1
                }
            
            for _ in 0..<days {
                var newFish = [Int: Int]()
                for fishIndex in fishMap.keys {
                    if fishIndex == 0 {
                        newFish[6, default: 0] += fishMap[0, default: 0]
                        newFish[8, default: 0] = fishMap[0, default: 0]
                    } else {
                        newFish[fishIndex-1, default: 0] += fishMap[fishIndex, default: 0]
                    }
                }
                fishMap = newFish
            }
            
            let count = fishMap.reduce(into: 0) { partialResult, map in
                partialResult += map.value
            }
            
            return "\(count)"
        }
        
        func part1() -> String {
            passTime(days: 80)
        }
        
        func part2() -> String {
            passTime(days: 256)
        }
    }
}
