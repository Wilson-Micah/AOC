//
//  Day18.swift
//  AOC
//
//  Created by Micah Wilson on 12/17/21.
//

import Algorithms
import Foundation

extension AOC21 {
    struct Day18: Day {
        struct SnailFish {
            var lhs: SnailFishType
            var rhs: SnailFishType
            
            init(line: inout [String]) {
                lhs = Self.parseValue(line: &line)
                line.removeFirst()
                rhs = Self.parseValue(line: &line)
                line.removeFirst()
            }
            
            init(lhs: SnailFishType, rhs: SnailFishType) {
                self.lhs = lhs
                self.rhs = rhs
            }
            
            static func parseValue(line: inout [String]) -> SnailFishType {
                let start = line.removeFirst()
                if start == "[" {
                    return SnailFishType.pair(SnailFish.init(line: &line))
                } else {
                    let value = Int(start)!
                    return SnailFishType.value(value)
                }
            }
            
            mutating func explodeLeft(l: Int, r: Int) {
                switch lhs {
                case let .value(val):
                    lhs = .value(val + l)
                case .pair:
                    lhs = .value(0)
                }
                
                switch rhs {
                case let .value(val):
                    rhs = .value(val + r)
                case var .pair(fish):
                    fish.carryExplosionRight(val: r)
                    rhs = .pair(fish)
                }
            }
            
            mutating func carryExplosionLeft(val: Int) {
                switch lhs {
                case .value(let int):
                    lhs = .value(int + val)
                case .pair(var snailFish):
                    snailFish.carryExplosionAlwaysRight(val: val)
                    lhs = .pair(snailFish)
                }
            }
            
            mutating func carryExplosionAlwaysLeft(val: Int) {
                switch lhs {
                case .value(let int):
                    lhs = .value(int + val)
                case .pair(var snailFish):
                    snailFish.carryExplosionAlwaysLeft(val: val)
                    lhs = .pair(snailFish)
                }
            }
            
            mutating func carryExplosionRight(val: Int) {
                switch rhs {
                case .value(let int):
                    rhs = .value(int + val)
                case .pair(var snailFish):
                    snailFish.carryExplosionAlwaysLeft(val: val)
                    rhs = .pair(snailFish)
                }
            }
            
            mutating func carryExplosionAlwaysRight(val: Int) {
                switch rhs {
                case .value(let int):
                    rhs = .value(int + val)
                case .pair(var snailFish):
                    snailFish.carryExplosionAlwaysRight(val: val)
                    rhs = .pair(snailFish)
                }
            }
            
            mutating func reduce() {
                var needsWork = false
                repeat {
                    needsWork = false
                    while explode(nest: 0) != nil {
                        needsWork = true
                    }
                    if split() {
                        needsWork = true
                    }
                } while needsWork
            }
            
            @discardableResult
            mutating func explode(nest: Int) -> (lhs: Int, rhs: Int)? {
                if nest == 4 {
                    switch (lhs, rhs) {
                    case let (.value(l), .value(r)):
                        return (lhs: l, rhs: r)
                    default:
                        return nil
                    }
                }
                
                switch lhs {
                case .value:
                    break
                case .pair(var snailFish):
                    if let explosion = snailFish.explode(nest: nest + 1) {
                        carryExplosionRight(val: explosion.rhs)
 
                        if nest == 3 {
                            lhs = .value(0)
                        } else {
                            lhs = .pair(snailFish)
                        }
                        return (lhs: explosion.lhs, rhs: 0)
                    }
                }
                
                switch rhs {
                case .value:
                    break
                case .pair(var snailFish):
                    if let explosion = snailFish.explode(nest: nest + 1) {
                        carryExplosionLeft(val: explosion.lhs)
                        
                        if nest == 3 {
                            rhs = .value(0)
                        } else {
                            rhs = .pair(snailFish)
                        }
                        return (lhs: 0, rhs: explosion.rhs)
                    }
                }
                
                return nil
            }
            
            mutating func split() -> Bool {
                return lhs.split() || rhs.split()
            }
            
            var toString: String {
                return "[\(lhs.toString),\(rhs.toString)]"
            }
            
            var magnitude: Int {
                lhs.magnitude * 3 + rhs.magnitude * 2
            }
        }
        
        indirect enum SnailFishType {
            case value(Int)
            case pair(SnailFish)
            
            mutating func split() -> Bool {
                switch self {
                case let .value(val) where val > 9:
                    self = .pair(.init(
                        lhs: .value(Int(floor(Double(val) / 2))),
                        rhs: .value(Int(ceil(Double(val) / 2)))
                    ))
                    return true
                case var .pair(fish):
                    let split = fish.split()
                    self = .pair(fish)
                    return split
                default:
                    return false
                }
            }
            
            var magnitude: Int {
                switch self {
                case .value(let val):
                    return val
                case .pair(let fish):
                    return fish.magnitude
                }
            }
            
            var toString: String {
                switch self {
                case .value(let val):
                    return "\(val)"
                case .pair(let fish):
                    return fish.toString
                }
            }
        }
        
        var fish: [SnailFish] {
            input.lines.map { line -> SnailFish in
                var line = Array(line).map(String.init)
                line.removeFirst()
                return SnailFish(line: &line)
            }
        }
        
        func part1() -> String {
            var snailFishes = fish
            while snailFishes.count > 1 {
                var reduced = [SnailFish]()
                for var snailFish in snailFishes {
                    snailFish.reduce()
                    reduced.append(snailFish)
                }
                
                let first = reduced.removeFirst()
                let second = reduced.removeFirst()
                snailFishes = [SnailFish(lhs: .pair(first), rhs: .pair(second))] + reduced
            }
            
            var resultFish = snailFishes[0]
            resultFish.reduce()
            
            return "\(resultFish.magnitude)"
        }
        
        func part2() -> String {
            let reduced = fish.map { fish -> SnailFish in
                var fish = fish
                fish.reduce()
                return fish
            }

            let combos = reduced.combinations(ofCount: 2)
            
            let magnitudes = combos.map { combo -> Int in
                let first = combo.first!
                let second = combo.last!
                var sum1 = SnailFish(lhs: .pair(first), rhs: .pair(second))
                sum1.reduce()
                
                var sum2 = SnailFish(lhs: .pair(second), rhs: .pair(first))
                sum2.reduce()
                return max(sum1.magnitude, sum2.magnitude)
            }
            return "\(magnitudes.max()!)"
        }
    }
}
