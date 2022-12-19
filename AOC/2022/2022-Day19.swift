//
//  2022-Day19.swift
//  AOC
//
//  Created by Micah Wilson on 12/18/22.
//

import Algorithms
import Foundation

extension AOC22 {
    struct Day19: Day {
        struct Blueprint {
            let oreCost: Int
            let clayCost: Int
            let obsidianCost: (Int, Int)
            let geodeCost: (Int, Int)
            var timePassed = 1
            var counts = [1, 0, 0, 0]
            var inventory = [1, 0, 0, 0]

            var idealClay: Int {
                (obsidianCost.1 / obsidianCost.0) + 4
            }
            
            var timeToGeode: Int {
                if counts[0] == 0 || counts[2] == 0 { return -1 }
                return max(0, max(Int(ceil(Double(geodeCost.0 - inventory[0]) / Double(counts[0]))), Int(ceil(Double(geodeCost.1 - inventory[2]) / Double(counts[2])))))
            }
            
            var timeToObsidian: Int {
                if counts[0] == 0 || counts[1] == 0 { return -1 }
                return max(0, max(Int(ceil(Double(obsidianCost.0 - inventory[0]) / Double(counts[0]))), Int(ceil(Double(obsidianCost.1 - inventory[1]) / Double(counts[1])))))
            }
            
            var timeToClay: Int {
                max(0, Int(ceil(Double(clayCost - inventory[0]) / Double(counts[0]))))
            }
            
            var timeToOre: Int {
                max(0, Int(ceil(Double(oreCost - inventory[0]) / Double(counts[0]))))
            }
            
            var canBuyGeode: Bool {
                timeToGeode != -1
            }
            
            var canBuyObsidian: Bool {
                timeToObsidian != -1
            }
            
            static var best = [Int: Int]()
            
            static func advanceToNextRobot(blueprint: Blueprint, index: Int, time: Int = 24) -> Int {
                var blueprint = blueprint
                let oldTime = blueprint.timePassed
                let oldCount = blueprint.counts
                
                switch index {
                case 0:
                    let timeNeeded = blueprint.timeToOre
                    blueprint.timePassed += timeNeeded + 1
                    blueprint.counts[0] += 1
                    blueprint.inventory[0] -= blueprint.oreCost
                case 1:
                    let timeNeeded = blueprint.timeToClay
                    blueprint.timePassed += max(0, timeNeeded) + 1
                    blueprint.counts[1] += 1
                    blueprint.inventory[0] -= blueprint.clayCost
                case 2:
                    let timeNeeded = blueprint.timeToObsidian
                    blueprint.timePassed += max(0, timeNeeded) + 1
                    blueprint.counts[2] += 1
                    blueprint.inventory[0] -= blueprint.obsidianCost.0
                    blueprint.inventory[1] -= blueprint.obsidianCost.1
                case 3:
                    let timeNeeded = blueprint.timeToGeode
                    blueprint.timePassed += max(0, timeNeeded) + 1
                    blueprint.counts[3] += 1
                    blueprint.inventory[0] -= blueprint.geodeCost.0
                    blueprint.inventory[2] -= blueprint.geodeCost.1
                default:
                    break
                }
                
                for i in blueprint.inventory.indices {
                    blueprint.inventory[i] += (min(time, blueprint.timePassed) - oldTime) * oldCount[i]
                }
                
                if blueprint.timePassed >= time {
                    return blueprint.inventory[3]
                } else {
                    var tests = [Int]()
                    if blueprint.timeToGeode != -1 {
                        tests.append(advanceToNextRobot(blueprint: blueprint, index: 3, time: time))
                    }
                    if blueprint.timeToObsidian != -1 {
                        tests.append(advanceToNextRobot(blueprint: blueprint, index: 2, time: time))
                    }
                    if blueprint.counts[1] <= blueprint.idealClay {
                        tests.append(advanceToNextRobot(blueprint: blueprint, index: 1, time: time))
                    }
                    if blueprint.counts[0] <= blueprint.oreCost || blueprint.counts[0] <= blueprint.clayCost || blueprint.counts[0] < blueprint.obsidianCost.0 || blueprint.counts[0] < blueprint.geodeCost.0 {
                        tests.append(advanceToNextRobot(blueprint: blueprint, index: 0, time: time))
                    }
                    return tests.max()!
                }
            }
        }
        
        func part1() -> String {
            let blueprints = input.lines.map { line in
                let costs = line.spaces.ints
                return Blueprint(
                    oreCost: costs[0],
                    clayCost: costs[1],
                    obsidianCost: (costs[2], costs[3]),
                    geodeCost: (costs[4], costs[5])
                )
            }
            
            let score = blueprints.map {
                Blueprint.advanceToNextRobot(blueprint: $0, index: -1)
            }
                .enumerated()
                .reduce(into: 0) { partialResult, element in
                    partialResult += (element.offset + 1) * element.element
                }
            
            return "\(score)"
        }
        
        func part2() -> String {
            let blueprints = input.lines[0..<3].map { line in
                let costs = line.spaces.ints
                return Blueprint(
                    oreCost: costs[0],
                    clayCost: costs[1],
                    obsidianCost: (costs[2], costs[3]),
                    geodeCost: (costs[4], costs[5])
                )
            }
            
            let scores = blueprints.map {
                Blueprint.advanceToNextRobot(blueprint: $0, index: -1, time: 32)
            }
            
            return "\(scores)"
        }
    }
}
